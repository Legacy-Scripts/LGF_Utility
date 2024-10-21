local ClientCallback = {}
local clientCallbacks = {}
local currentRequestId = 0
local serverCallbacks = {}
local responses = {}

function LGF:RegisterClientCallback(name, cb)
    clientCallbacks[name] = cb
end

function LGF:TriggerClientCallback(name, ...)
    local invoker = GetInvokingResource()
    if clientCallbacks[name] then
        local result = clientCallbacks[name](...)
        return result
    else
        LGF:logError("Client Callback Not Found. Name: %s , Invoker: %s", name, invoker)
        return nil
    end
end

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
            LGF:logError(("Timeout for invoker Resource: %s, Callback Name: %s"):format(invoker, name))
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
    -- LGF:DebugValue("Received callback response for RequestId: %s, Result: %s", requestId, tostring(result))
    if serverCallbacks[requestId] then
        serverCallbacks[requestId](result)
        serverCallbacks[requestId] = nil
    else
        LGF:DebugValue("Callback function not found for requestId:", requestId)
    end
end)


exports('TriggerServerCallback', function(name, ...)
    return LGF:TriggerServerCallback(name, ...)
end)

exports('RegisterClientCallback', function(name, fun)
    return LGF:RegisterClientCallback(name, fun)
end)

exports('TriggerClientCallback', function(name, ...)
    return LGF:TriggerClientCallback(name, ...)
end)


return ClientCallback
