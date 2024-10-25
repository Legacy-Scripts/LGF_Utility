---@diagnostic disable: undefined-global, duplicate-set-field
local obj, frameworkName = LGF:GetFramework()
LGF.Core = {}

local function ERR_CORE(res)
    return LGF:logError("Unsupported framework: %s", res)
end

function LGF.Core:GetPlayer(target)
    if frameworkName == "LEGACYCORE" then
        return obj.DATA:GetPlayerDataBySlot(target)
    elseif frameworkName == "es_extended" then
        return obj.GetPlayerFromId(target)
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
    elseif frameworkName == "qb-core" then
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
    elseif frameworkName == "qb-core" then
        return PlayerData.license
    end
end

function LGF.Core:GetName(target)
    local PlayerData = LGF.Core:GetPlayer(target)
    if frameworkName == "LEGACYCORE" then
        return PlayerData.playerName
    elseif frameworkName == "es_extended" then
        return string.format("%s %s", PlayerData.get("firstName"), PlayerData.get("lastName"))
    elseif frameworkName == "qb-core" then
        return string.format("%s %s", PlayerData.charinfo.firstname, PlayerData.charinfo.lastname)
    end
end

function LGF.Core:GetPlayerAccount(target)
    if frameworkName == "LEGACYCORE" then
        local promise = obj.DATA:GetPlayerAccount(target)
        return promise
    elseif frameworkName == "es_extended" then

    elseif frameworkName == "qb-core" then

    end
end

LGF:RegisterServerCallback('LGF_Utility:Bridge:GetPlayerGroup', function(source)
    if not source or source <= 0 or type(source) ~= "number" then return ("Invalid source %S ?"):format(source) end
    if not GetPlayerName(source) then return "Player not found" end
    local Group = LGF.Core:GetGroup(source)
    if not Group then Group = "User" end
    return Group
end)

function LGF.Core:ManageAccount(target, amount, typetransition)

    if type(amount) == "string" then 
        amount = tonumber(amount) 
    end
    if frameworkName == "LEGACYCORE" then
        local PlayerSlot =  LGF.Core:GetPlayer(target).charIdentifier
        local PlayerData = LGF.Core:GetPlayer(target)
        local accountsData = json.decode(PlayerData.accounts)

        if typetransition == "add" then
            accountsData.Bank = (accountsData.Bank or 0) + amount
        elseif typetransition == "remove" then
            accountsData.Bank = math.max(0, (accountsData.Bank or 0) - amount)
        end

        local updatedAccounts = json.encode(accountsData)
        local updatePromise, updateError = MySQL.update.await( 'UPDATE `users` SET `accounts` = ? WHERE `identifier` = ? AND `charIdentifier` = ?', { updatedAccounts, PlayerData.identifier, PlayerSlot }
        )
        if updateError then
            print('Error updating LEGACYCORE account:', updateError)
        end

    elseif frameworkName == "es_extended" then
        local xPlayer = ESX.GetPlayerFromId(target)
        if xPlayer then
            if typetransition == "add" then
                xPlayer.addAccountMoney('bank', amount)
            elseif typetransition == "remove" then
                xPlayer.removeAccountMoney('bank', amount)
            end
        end

    elseif frameworkName == "qb-core" then
        local player = QBCore.Functions.GetPlayer(target)
        if player then
            if typetransition == "add" then
                player.Functions.AddMoney('bank', amount)
            elseif typetransition == "remove" then
                player.Functions.RemoveMoney('bank', amount)
            end
        end
    end
end

return {
    GetName = LGF.Core.GetName,
    GetPlayer = LGF.Core.GetPlayer,
    GetGroup = LGF.Core.GetGroup,
    GetIdentifier = LGF.Core.GetIdentifier,
    GetPlayerAccount = LGF.Core.GetPlayerAccount,
    ManageAccount = LGF.Core.ManageAccount,
}
