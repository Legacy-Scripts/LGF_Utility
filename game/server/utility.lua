function LGF:isPlayerOnline(source)
    local Players = GetPlayers()
    for I = 1, #Players do
        local target = Players[I]
        if tostring(target) == tostring(source) then
            return true
        end
    end
    return false
end
