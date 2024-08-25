DEBUG = {}

local GetConvarDebug = GetConvar('LGF_UI:Utility:EnableDebug', "true")


function DEBUG:DebugValue(format, ...)
    if GetConvarDebug == "false" then return end
    print(("[^3DEBUG^7] " .. format):format(...))
end

function DEBUG:logError(message, ...)
    if GetConvarDebug == "false" then return end
    print(string.format("ERROR: " .. message, ...))
end

return DEBUG
