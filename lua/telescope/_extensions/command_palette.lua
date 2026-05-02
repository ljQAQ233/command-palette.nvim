local themes = require "telescope.themes"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require "telescope.pickers.entry_display"
local conf = require("telescope.config").values
local resolve = require "telescope.config.resolve"

local categories
local CpMenu = require("command_palette").CpMenu

local function setup(cpMenu)
  require("command_palette").CpMenu = cpMenu or {}
  CpMenu = require("command_palette").CpMenu
end

function themes.vscode(opts)
  opts = opts or {}
  local theme_opts = {
    theme = "dropdown",
    results_title = false,
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      anchor = "N",
      prompt_position = "top",
      width = function(_, max_columns, _)
        return math.min(max_columns, 120)
      end,
      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = {
        "─",
        "│",
        "─",
        "│",
        "╭",
        "╮",
        "╯",
        "╰",
      },
      results = {
        "─",
        "│",
        "─",
        "│",
        "╭",
        "╮",
        "┤",
        "├",
      },
      preview = {
        "─",
        "│",
        "─",
        "│",
        "╭",
        "╮",
        "╯",
        "╰",
      },
    }
  end
  return vim.tbl_deep_extend("force", theme_opts, opts)
end

--- create an item to describe a selectable entry
---@param raw PaletteSelection
---@return PaletteSelection
local function make_selection(raw)
  return {
    name = selection_attr(raw, "n"),
    desc = selection_attr(raw, "d"),
    ops = selection_attr(raw, "o"),
  }
end

-- generate a table to display
-- strip the first item, i.e. name of this menu
local function extract_menu(menu)
  local results = {}
  local j = 1
  for i = vim.tbl_count(menu), 1, -1 do
    -- type table means this is a selection
    if type(menu[i]) == "table" then
      results[j] = make_selection(menu[i])
      j = j + 1
    end
  end
  return results
end

local function menu_name(menu)
  return menu[1] or menu.name
end

---@alias PaletteOperation
---| table sub-level menu
---| string vimscript
---| function lua function

---@class PaletteSelection
---@field name string
---@field desc string
---@field ops PaletteOperation

---@alias PaletteAttribute
---| 'n' name
---| 'd' description
---| 'o' operations

--- get an iterm's attribute as per attribute
---@param selection PaletteSelection
---@param attribute PaletteAttribute
---@return string|PaletteOperation|nil
function selection_attr(selection, attribute)
  assert(type(selection) == "table")
  -- get name
  if attribute == "n" then
    return selection.name or selection[1]
  -- get description
  elseif attribute == "d" then
    if selection.desc ~= nil then
      return selection.desc
    end
    local desc_slot = selection[3]
    if desc_slot ~= nil and type(desc_slot) == "string" then
      return desc_slot
    end
  -- get operations
  elseif attribute == "o" then
    if selection.ops ~= nil then
      return selection.ops
    end
    local op_slot = selection[2]
    if op_slot ~= nil and (type(op_slot) == "string" or type(op_slot) == "function") then
      return op_slot
    end
    return extract_menu(selection)
  end
  return ""
end

categories = function(opts, menu)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = menu_name(menu),
      finder = finders.new_table {
        results = extract_menu(menu),
        entry_maker = function(entry)
          local item = entry
          local results_win = vim.api.nvim_get_current_win()
          local w = vim.api.nvim_win_get_width(results_win)
          local h = vim.api.nvim_win_get_height(results_win)
          local width = conf.width
            or conf.layout_config.width
            or conf.layout_config[conf.layout_strategy].width
            or vim.o.columns
          local tel_win_width = resolve.resolve_width(width)(nil, w, h) - #conf.selection_caret
          local desc_width = math.floor(tel_win_width * 0.05)
          local command_width = 28

          -- NOTE: the width calculating logic is not exact, but approx enough
          local displayer = entry_display.create {
            separator = " ▏",
            items = {
              { width = command_width },
              { width = tel_win_width - desc_width - command_width },
              { remaining = true },
            },
          }

          local name = item.name
          local desc = item.desc
          assert(type(name) == "string")
          assert(type(desc) == "string")

          local function make_display()
            return displayer {
              { name },
              { desc },
            }
          end

          return {
            value = item,
            display = make_display,
            ordinal = string.format("%s %s", name, desc),
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          -- temporarily workaround for telescope issue: 1599.
          -- vim.schedule(function()
          --   vim.cmd "startinsert! "
          -- end)
          ---@type PaletteSelection
          local op = action_state.get_selected_entry().value.ops
          if type(op) == "string" then
            vim.api.nvim_exec2(op, { output = true })
          elseif type(op) == "table" then
            categories(opts, op)
          end
        end)
        return true
      end,
    })
    :find()
end

local function run()
  categories(require("telescope.themes").vscode {}, CpMenu)
end

return require("telescope").register_extension {
  setup = setup,
  exports = {
    -- Default when to argument is given, i.e. :Telescope command_palette
    command_palette = run,
  },
}
