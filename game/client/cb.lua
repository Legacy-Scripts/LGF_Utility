
local ClientCallback = {}

local currentRequestId = 0
local serverCallbacks = {}
local responses = {}


function LGF:TriggerServerCallback(name, ...)
    currentRequestId = currentRequestId + 1
    local requestId = currentRequestId
    local timeout = 5000
    local startTime = GetGameTimer()
    local invoker = GetInvokingResource()

    serverCallbacks[requestId] = function(result)
        responses[requestId] = result
    end

    TriggerServerEvent("LGF_UI:server:Callback", name, requestId, invoker, ...)

    while responses[requestId] == nil do
        Citizen.Wait(0)
        if GetGameTimer() - startTime > timeout then
            DEBUG:logError(("Timeout for invoker Resource: %s, Callback Name: %s"):format(invoker, name))
            responses[requestId] = nil
            break
        end
    end

    local result = responses[requestId]
    responses[requestId] = nil
    return result
end


RegisterNetEvent("LGF_UI:client:CallbackResponse")
AddEventHandler("LGF_UI:client:CallbackResponse", function(requestId, result)
    DEBUG:DebugValue("Received callback response for RequestId: %s, Result: %s", requestId, tostring(result))
    if serverCallbacks[requestId] then
        serverCallbacks[requestId](result)
        serverCallbacks[requestId] = nil
    else
        DEBUG:DebugValue("Callback function not found for requestId:", requestId)
    end
end)


exports('TriggerServerCallback', function(name, ...)
    return LGF:TriggerServerCallback(name, ...)
end)


return ClientCallback
