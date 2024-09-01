local obj, frameworkName = LGF:GetFramework()
LGF.Core = {}

local function ERR_CORE(res)
    return LGF:logError("Unsupported framework: %s", res)
end


if LGF:GetContext() == "client" then
    function LGF.Core:GetPlayer()
        if frameworkName == "LEGACYCORE" then
            return obj.DATA:GetPlayerObject() or LocalPlayer.state.GetPlayerObject
        elseif frameworkName == "es_extended" then
            return obj.GetPlayerData()
        elseif frameworkName == "qbx_core" then
            return exports.qbx_core:GetPlayerData()
        else
            ERR_CORE(frameworkName)
        end
    end

    function LGF.Core:GetJob()
        local playerData = LGF.Core:GetPlayer()
        if frameworkName == "LEGACYCORE" then
            return playerData.JobName
        elseif frameworkName == "es_extended" then
            return playerData.job and playerData.job.name or "Unknown"
        elseif frameworkName == "qbx_core" then
            return playerData.job and playerData.job.name or "Unknown"
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
        elseif frameworkName == "qbx_core" then
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
            elseif frameworkName == "qbx_core" then
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
        elseif frameworkName == "qbx_core" then
            return PlayerData.charinfo.gender
        end
    end

    function LGF.Core:GetGroup()
        local response = LGF:TriggerServerCallback("LGF_Utility:Bridge:GetPlayerGroup")
        return response
    end

    print(LGF.Core:GetGroup(), LGF.Core:GetName(), LGF.Core:GetJob(), LGF.Core:GetPlayer(), LGF.Core:GetIdentifier(),LGF.Core:GetGender())
end

return {
    GetPlayer = LGF.Core.GetPlayer,
    GetPlayerJob = LGF.Core.GetJob,
    GetName = LGF.Core.GetName,
    GetIdentifier = LGF.Core.GetIdentifier,
    GetGender = LGF.Core.GetGender,
    GetGroup = LGF.Core.GetGroup,
}
