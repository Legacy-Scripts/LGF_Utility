ServerCallback = {}

function LGF:RegisterServerCallback(name, cb)
    ServerCallback[name] = cb
end

RegisterNetEvent("LGF_UI:server:Callback")
AddEventHandler("LGF_UI:server:Callback", function(name, requestId, invoker, ...)
    local source = source
    local invokingResource = invoker

    local result

    if ServerCallback[name] then
        result = ServerCallback[name](source, ...)
    else
        LGF:logError("Callback Not Found. Name: %s, RequestId: %s, Invoking Resource: %s", name, requestId,invokingResource)
    end

    TriggerClientEvent("LGF_UI:client:CallbackResponse", source, requestId, result)
end)


exports('RegisterServerCallback', function(name, cb)
    return LGF:RegisterServerCallback(name, cb)
end)


return ServerCallback
