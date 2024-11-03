local obj, frameworkName = LGF:GetFramework()
LGF.Core = {}

local function ERR_CORE(res)
    return LGF:logError("Unsupported framework: %s", res)
end

function LGF.Core:GetPlayer()
    if frameworkName == "LEGACYCORE" then
        return obj.DATA:GetPlayerObject() or LocalPlayer.state.GetPlayerObject
    elseif frameworkName == "es_extended" then
        return obj.GetPlayerData()
    elseif frameworkName == "qb-core" then
        return obj.Functions.GetPlayerData()
    else
        ERR_CORE(frameworkName)
    end
end

function LGF.Core:GetJob()
    local playerData = LGF.Core:GetPlayer()
    if frameworkName == "LEGACYCORE" then
        return playerData.JobName
    elseif frameworkName == "es_extended" then
        return playerData.job and playerData.job.name
    elseif frameworkName == "qb-core" then
        return playerData.job and playerData.job.name
    else
        ERR_CORE(frameworkName)
    end
end

function LGF.Core:GetJobGrade()
    local playerData = LGF.Core:GetPlayer()
    if frameworkName == "LEGACYCORE" then
        return playerData.JobGrade
    elseif frameworkName == "es_extended" then
        return playerData.job and playerData.job.grade
    elseif frameworkName == "qb-core" then
        return playerData.job and playerData.job.grade
    else
        ERR_CORE(frameworkName)
    end
end

function LGF.Core:GetName()
    local playerData = LGF.Core:GetPlayer()
    if frameworkName == "LEGACYCORE" then
        return string.format("%s", playerData.playerName)
    elseif frameworkName == "es_extended" then
        return string.format("%s %s", playerData.firstName, playerData.lastName)
    elseif frameworkName == "qb-core" then
        return string.format("%s %s", playerData.charinfo.firstname, playerData.charinfo.lastname)
    else
        ERR_CORE(frameworkName)
    end
end

function LGF.Core:GetIdentifier()
    local PlayerData = LGF.Core:GetPlayer()
    if PlayerData then
        if frameworkName == "LEGACYCORE" then
            return PlayerData.identifier
        elseif frameworkName == "es_extended" then
            return PlayerData.identifier
        elseif frameworkName == "qb-core" then
            return PlayerData.license
        end
    end
end

function LGF.Core:GetGender()
    local PlayerData = LGF.Core:GetPlayer()
    if frameworkName == "LEGACYCORE" then
        return PlayerData.sex
    elseif frameworkName == "es_extended" then
        return PlayerData.sex
    elseif frameworkName == "qb-core" then
        return PlayerData.charinfo.gender
    end
end

function LGF.Core:GetGroup()
    local response = LGF:TriggerServerCallback("LGF_Utility:Bridge:GetPlayerGroup")
    return response
end

function LGF.Core:GetPlayerAccount()
    if frameworkName == "LEGACYCORE" then
        local promise = obj.DATA:GetPlayerMetadata('accounts')
        local Decoded = json.decode(promise)
        return { Bank = Decoded.Bank, Cash = Decoded.money }
    elseif frameworkName == "es_extended" then

    elseif frameworkName == "qb-core" then

    end
end

LocalPlayer.state.IsLoaded = false


if frameworkName == "LEGACYCORE" then
    AddEventHandler('LegacyCore:PlayerLoaded', function(...)
        TriggerEvent("LGF_Utility:PlayerLoaded", ...)
        LocalPlayer.state.IsLoaded = true
    end)
elseif frameworkName == "es_extended" then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(...)
        TriggerEvent("LGF_Utility:PlayerLoaded", ...)
        LocalPlayer.state.IsLoaded = true
    end)
elseif frameworkName == "qbx_core" or frameworkName == "qb-core" then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function(...)
        TriggerEvent("LGF_Utility:PlayerLoaded", ...)
        LocalPlayer.state.IsLoaded = true
    end)
end

if frameworkName == "LEGACYCORE" then
    AddEventHandler('LegacyCore:PlayerLogout', function(...)
        TriggerEvent("LGF_Utility:PlayerUnloaded", ...)
        LocalPlayer.state.IsLoaded = false
    end)
elseif frameworkName == "es_extended" then
    RegisterNetEvent('esx:onPlayerLogout')
    AddEventHandler('esx:onPlayerLogout', function(...)
        TriggerEvent("LGF_Utility:PlayerUnloaded", ...)
        LocalPlayer.state.IsLoaded = false
    end)
elseif frameworkName == "qbx_core" or frameworkName == "qb-core" then
    RegisterNetEvent('QBCore:Client:OnPlayerUnload')
    AddEventHandler('QBCore:Client:OnPlayerUnload', function(...)
        TriggerEvent("LGF_Utility:PlayerUnloaded", ...)
        LocalPlayer.state.IsLoaded = false
    end)
end


function LGF.Core:PlayerLoaded()
    return LocalPlayer.state.IsLoaded
end

RegisterNetEvent("LGF_Utility:PlayerLoaded", function(...)
    local argss = { ... }
end)

return {
    IsLoaded = LGF.Core.PlayerLoaded,
    GetPlayer = LGF.Core.GetPlayer,
    GetPlayerJob = LGF.Core.GetJob,
    GetName = LGF.Core.GetName,
    GetIdentifier = LGF.Core.GetIdentifier,
    GetGender = LGF.Core.GetGender,
    GetGroup = LGF.Core.GetGroup,
}
