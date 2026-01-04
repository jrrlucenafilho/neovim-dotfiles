-- Helper loggin function so copilot.lua doesnt get comlained about
local M = {}

M.setup = function()
  if _G.logger ~= nil then
    return
  end

  _G.logger = {
    debug = function(...) end,
    info  = function(...) end,
    warn  = function(...) end,
    error = function(...) end,
  }
end

return M

