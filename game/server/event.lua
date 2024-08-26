function LGF:TriggerClientEvent(eventName, playerId, ...)

    if type(playerId) ~= "number" then
        return false, "Invalid player ID: must be a number"
    end

    if type(eventName) ~= "string" or eventName == "" then
        return false
    end

    local args = { ... }

    local success = TriggerClientEvent(eventName, playerId, table.unpack(args))

    if not success then
        return false, ("Failed to trigger client event %s for player ID %d"):format(eventName, playerId)
    end

    return true
end
