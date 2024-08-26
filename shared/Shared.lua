DEBUG = {}

local GetConvarDebug = GetConvar('LGF_UI:Utility:EnableDebug', "true")

function DEBUG:DebugValue(format, ...)
    if GetConvarDebug == "false" then return end
    print(("[^3DEBUG^7] " .. format):format(...))
end

function DEBUG:logError(message, ...)
    print(("^1[ERROR]^7 " .. message):format(...))
end


function LGF:GetDependency(resource_name, required_version)
    local state = GetResourceState(resource_name)

    if state ~= "started" then
        return false
    end

    local current_version = GetResourceMetadata(resource_name, 'version', 0)

    if current_version ~= required_version then
        return false,DEBUG:DebugValue(( "^1[ERROR]^7 The version of resource ^1[%s]^7 does not match the required version. Required: ^3%s^7"):format(resource_name,required_version))
    end

    return true
end

return DEBUG
