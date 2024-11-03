local GetConvarDebug = GetConvar('LGF_Utility:EnableDebug', "true")

function LGF:DebugValue(format, ...)
    if GetConvarDebug == "false" then return end
    print(("[^3DEBUG^7] " .. format):format(...))
end

function LGF:logError(message, ...)
    print(("^1[ERROR]^7 " .. message):format(...))
end

local function parseVersion(version)
    local parts = {}
    for part in version:gmatch("%d+") do
        table.insert(parts, tonumber(part))
    end
    return parts
end

local function isMinimumVersion(current_version, required_version)
    local current = parseVersion(current_version)
    local required = parseVersion(required_version)

    for i = 1, math.max(#current, #required) do
        local current_part = current[i] or 0
        local required_part = required[i] or 0

        if current_part > required_part then
            return true
        elseif current_part < required_part then
            return false
        end
    end

    return true
end

--[[GET DEPENDENCY]]
function LGF:GetDependency(resource_name, required_version)
    local state = GetResourceState(resource_name)

    if state ~= "started" then
        return false, ("The resource ^1[%s]^7 is not started."):format(resource_name)
    end

    local current_version = GetResourceMetadata(resource_name, 'version', 0)

    if not isMinimumVersion(current_version, required_version) then
        return false,("^1[ERROR]^7 The version of resource ^1[%s]^7 does not meet the minimum required version. Required: ^3%s^7 or higher, Found: ^3%s^7") :format(resource_name, required_version, current_version)
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
