local M = {}

M.onServerLeave = function ()
    extensions.unload("extension")
end

return M