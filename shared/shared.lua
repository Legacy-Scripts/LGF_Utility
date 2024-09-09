local GetConvarDebug = GetConvar('LGF_Utility:EnableDebug', "true")

function LGF:DebugValue(format, ...)
    if GetConvarDebug == "false" then return end
    print(("[^3DEBUG^7] " .. format):format(...))
end

function LGF:logError(message, ...)
    print(("^1[ERROR]^7 " .. message):format(...))
end

--[[GET DEPENDENCY]]
function LGF:GetDependency(resource_name, required_version)
    local state = GetResourceState(resource_name)

    if state ~= "started" then
        return false
    end

    local current_version = GetResourceMetadata(resource_name, 'version', 0)

    if current_version ~= required_version then
        return false,
            LGF:DebugValue(("^1[ERROR]^7 The version of resource ^1[%s]^7 does not match the required version. Required: ^3%s^7")
                :format(resource_name, required_version))
    end
    return true
end

function LGF:SafeAsyncWait(delay, func)
    assert(type(delay) == "number" and delay > 0, "Delay must be a positive number.")

    local co = coroutine.running()

    Citizen.CreateThread(function()
        Citizen.Wait(delay)
        local success, result = pcall(func)

        if not success then
            LGF:logError("Async function failed %s:", result)
        end

        coroutine.resume(co, success, result)
    end)

    return coroutine.yield()
end



