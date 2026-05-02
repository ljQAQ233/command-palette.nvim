local M = {}

--- transform a LinArcX-version style config to be applied to the new version
---@param oldver table -- old-style configurations
M.migrate = function(oldver)
  local newver = { "Command Palette" }
  for _, category in pairs(oldver) do
    local submenu = { category[1] }
    for _, command in pairs(category) do
      if type(command) == "table" then
        local op = {
          command[1],
          command[2],
        }
        table.insert(submenu, op)
      end
    end
    table.insert(newver, submenu)
  end
  return newver
end
M.CpMenu = {}

return M
