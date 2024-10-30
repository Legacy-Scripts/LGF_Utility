function LGF:isPlayerOnline(source)
    for _, player in ipairs(GetPlayers()) do
        if tostring(player) == tostring(source) then
            return true
        end
    end
    return false
end


