<!-- panvimdoc-ignore-start -->
# command-palette.nvim
<!-- panvimdoc-ignore-end -->

# Introduction

`command-palette.nvim` is a neovim plugin written entirely in lua that will help you to access your custom commands/function/key-bindings.

This plugin is a fork of [LinArcX/telescope-command-palette.nvim](https://github.com/LinArcX/telescope-command-palette.nvim), with extra features and improvements maintained by me.

The original repository is no longer actively maintained.

<!-- panvimdoc-ignore-start -->

# Demo

![Demo](https://user-images.githubusercontent.com/10884422/148601223-5ade5806-9935-4ff7-888c-d00b41178a96.gif)

<!-- panvimdoc-ignore-end -->

# Installation

```viml
Plug "nvim-telescope/telescope.nvim"
Plug "ljQAQ233/command-palette.nvim"
```

```lua
use { "nvim-telescope/telescope.nvim" }
use { "ljQAQ233/command-palette.nvim" }
```

## Configurations

First set up your commands in your Telescope config:

```lua
require("telescope").setup({
  extensions = {
    command_palette = {
      "Command Palette",
      {
        "File",
        { "entire selection", ":call feedkeys(\"GVgg\")" },
        { "save current file)", ":w" },
        { "save all files", ":wa" },
        { "quit", ":qa" },
        { "file browser", ":lua require'telescope'.extensions.file_browser.file_browser()" },
        { "search word", ":lua require('telescope.builtin').live_grep()" },
        { "git files", ":lua require('telescope.builtin').git_files()" },
        { "files", ":lua require('telescope.builtin').find_files()" },
      },
      {
        "Help",
        { "tips", ":help tips" },
        { "cheatsheet", ":help index" },
        { "tutorial", ":help tutor" },
        { "summary", ":help summary" },
        { "quick reference", ":help quickref" },
        { "search help", ":lua require('telescope.builtin').help_tags()" },
      },
      {
        "Vim",
        { "reload vimrc", ":source $MYVIMRC" },
        { "check health", ":checkhealth" },
        { "jumps", ":lua require('telescope.builtin').jumplist()" },
        { "commands", ":lua require('telescope.builtin').commands()" },
        { "command history", ":lua require('telescope.builtin').command_history()" },
        { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
        { "colorshceme", ":lua require('telescope.builtin').colorscheme()" },
        { "vim options", ":lua require('telescope.builtin').vim_options()" },
        { "keymaps", ":lua require('telescope.builtin').keymaps()" },
        { "buffers", ":Telescope buffers" },
        { "search history", ":lua require('telescope.builtin').search_history()" },
        { "paste mode", ":set paste!" },
        { "cursor line", ":set cursorline!" },
        { "cursor column", ":set cursorcolumn!" },
        { "spell checker", ":set spell!" },
        { "relative number", ":set relativenumber!" },
        { "search highlighting", ":set hlsearch!" },
      },
    },
  },
})
```

And then load the extension:

```lua
require('telescope').load_extension('command_palette')
```

The idea is that you declare some **categories**("Help", "Vim", etc..) and inside each category, you define your commands.
Each command has three parts:
- __description__(mandatory)
- __command__(mandatory)
- __insert_mode/normal_mode flag__(optional) (indicates that whether you want to be in insert_mode after run the command or not. **1** means: insert mode. **everything else** is normal mode)

Tip: `CpMenu` is just a simple [table](https://www.lua.org/pil/2.5.html).
Note: insertion to `CpMenu` should be after the extension is loaded (`load_extension`)

## Old-ver migration

If you have used the original version of `telescope-command-palette`, you can migrate your configuration to this version with `migrate()`.

```diff
require("telescope").setup({
require("telescope").setup({
  extensions = {
-   command_palette = {
+   command_palette = require("command_palette").migrate({
      {
        "File",
        { "entire selection", ":call feedkeys(\"GVgg\")" },
      },
-   }
+   })
  }
})
```

Or you can do so manually as per the customization doc:
  1. Insert a string of "Command Palette" in the start of table
  2. Remove the `commands`-level table's third field (`1` or `true`)

## Per-project config

If you're working on different projects and want to have special key_bindings per project, you can create a `.nvimrc` file in root of your project and append items to `CpMenu` like this:

```lua
table.insert(require("command_palette").CpMenu, {
  "Dap",
  { "pause", ":lua require'dap'.pause()" },
  { "step into", ":lua require'dap'.step_into()" },
  { "step back", ":lua require'dap'.step_back()" },
  { "step over", ":lua require'dap'.step_over()" },
  { "step out", ":lua require'dap'.step_out()" },
  { "frames", ":lua require'telescope'.extensions.dap.frames{}" },
  { "current scopes", ":lua ViewCurrentScopes(); vim.cmd(\"wincmd w|vertical resize 40\")" },
  { "current scopes floating window", ":lua ViewCurrentScopesFloatingWindow()" },
  { "current value floating window", ":lua ViewCurrentValueFloatingWindow()" },
  { "commands", ":lua require'telescope'.extensions.dap.commands{}" },
  { "configurations", ":lua require'telescope'.extensions.dap.configurations{}" },
  { "repl", ":lua require'dap'.repl.open(); vim.cmd(\"wincmd w|resize 12\")" },
  { "close", ":lua require'dap'.close(); require'dap'.repl.close()" },
  { "run to cursor", ":lua require'dap'.run_to_cursor()" },
  { "continue", ":lua require'dap'.continue()" },
  { "clear breakpoints", ":lua require('dap.breakpoints').clear()" },
  { "brakpoints", ":lua require'telescope'.extensions.dap.list_breakpoints{}" },
  { "toggle breakpoint", ":lua require'dap'.toggle_breakpoint()" },
})
```

# Default mappings

| Key   | Description                                                   |
| ---   | ------------------------------------------------------------- |
| `c-b` | go back to categories                                         |

# Usage

`:Telescope command_palette`.


<!-- panvimdoc-ignore-start -->

# Develop

```shell
git clone https://github.com/ljQAQ233/command-palette.nvim
```

- `make clean` - clean built docs and rubbish
- `make gendoc` - generate vimdoc in `doc/`
- `make opendoc` - open vimdoc in nvim

<!-- panvimdoc-ignore-end -->
