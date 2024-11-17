local htmlTexture = require("vehicle/htmlTexture")
local newOrig = htmlTexture.new
local createOrig = htmlTexture.create
local callOrig = htmlTexture.call
local M = {}

htmlTexture.call = function(webViewTag, jsMethod, data)
end

htmlTexture.create = function(webViewTag, uri, width, height, fps, usagemode)

  local usageModeID = 0 -- UI_TEXTURE_USAGE_ONCE
  fps = 0

  obj:createWebView(webViewTag, uri, width, height, usageModeID, fps)
end

htmlTexture.new = function(webViewTag, uri, width, height, fps, usagemode)

  local r = {webViewTag = webViewTag, uri = uri, width = width, height = height}
  local usageModeID = 0 -- UI_TEXTURE_USAGE_ONCE
  fps = 0

  r.fps = fps
  r.usageModeID = usageModeID

  obj:createWebView(r.webViewTag, r.uri, r.width, r.height, r.usageModeID, r.fps)
  return setmetatable(r, {__index = {callJS = function() end, streamJS = function() end}})
end



if not v.config.isPlayerVehicle then
    M.new = htmlTexture.new
    M.create = htmlTexture.create
    M.call = htmlTexture.call
else
    M.new = newOrig
    M.create = createOrig
    M.call = callOrig
end

return M