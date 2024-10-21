---@diagnostic disable: undefined-global, duplicate-set-field
local obj, frameworkName = LGF:GetFramework()
LGF.Core = {}

local function ERR_CORE(res)
    return LGF:logError("Unsupported framework: %s", res)
end

function LGF.Core:GetPlayer(target)
    if frameworkName == "LEGACYCORE" then
        print(json.encode(obj))
        return obj.DATA:GetPlayerDataBySlot(target)
    elseif frameworkName == "es_extended" then
        return obj.GetPlayerFromId(target)
    elseif frameworkName == "qbx_core" then
        return exports.qbx_core:GetPlayer(tonumber(target)).PlayerData
    elseif frameworkName == "qb-core" then
        return obj.Functions.GetPlayer(target).PlayerData
    else
        ERR_CORE(frameworkName)
    end
end

function LGF.Core:GetGroup(target)
    local PlayerData = LGF.Core:GetPlayer(target)
    local playerGroup = nil
    if not PlayerData then return end
    if frameworkName == "LEGACYCORE" then
        playerGroup = PlayerData.playerGroup
    elseif frameworkName == "es_extended" then
        playerGroup = PlayerData.getGroup()
    elseif frameworkName == "qbx_core" or frameworkName == "qb-core" then
        if IsPlayerAceAllowed(target, 'admin') then
            playerGroup = 'admin'
        elseif IsPlayerAceAllowed(target, 'god') then
            playerGroup = 'god'
        else
            return "User"
        end
    end
    return playerGroup
end

function LGF.Core:GetIdentifier(target)
    local PlayerData = LGF.Core:GetPlayer(target)
    if frameworkName == "LEGACYCORE" then
        return PlayerData.identifier
    elseif frameworkName == "es_extended" then
        return PlayerData.identifier
    elseif frameworkName == "qbx_core" then
        return PlayerData.license
    end
end

function LGF.Core:GetName(target)
    local PlayerData = LGF.Core:GetPlayer(target)
    if frameworkName == "LEGACYCORE" then
        return PlayerData.playerName
    elseif frameworkName == "es_extended" then
        return string.format("%s %s", PlayerData.get("firstName"), PlayerData.get("lastName"))
    elseif frameworkName == "qbx_core" or frameworkName == "qb-core" then
        return string.format("%s %s", PlayerData.charinfo.firstname, PlayerData.charinfo.lastname)
    end
end

LGF:RegisterServerCallback('LGF_Utility:Bridge:GetPlayerGroup', function(source)
    if not source or source <= 0 or type(source) ~= "number" then return ("Invalid source %S ?"):format(source) end
    if not GetPlayerName(source) then return "Player not found" end
    local Group = LGF.Core:GetGroup(source)
    if not Group then Group = "User" end
    return Group
end)


return {
    GetName = LGF.Core.GetName,
    GetPlayer = LGF.Core.GetPlayer,
    GetGroup = LGF.Core.GetGroup,
    GetIdentifier = LGF.Core.GetIdentifier,
}
