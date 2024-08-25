ServerCallback = {}
FNCS = {}

print('STARTING SERVER CB')

function FNCS:RegisterSvCallback(name, cb)
    ServerCallback[name] = cb
end

RegisterNetEvent("LGF_UI:server:Callback")
AddEventHandler("LGF_UI:server:Callback", function(name, requestId, invoker, ...)
    local source = source
    local invokingResource = invoker
    print(invokingResource)

    local result

    if ServerCallback[name] then
        result = ServerCallback[name](source, ...)
    else
        DEBUG:logError("Callback Not Found. Name: %s, RequestId: %s, Invoking Resource: %s", name, requestId, invokingResource)
    end

    TriggerClientEvent("LGF_UI:client:CallbackResponse", source, requestId, result)
end)


exports('RegisterServerCallback', function(name, cb)
    return FNCS:RegisterSvCallback(name, cb)
end)
