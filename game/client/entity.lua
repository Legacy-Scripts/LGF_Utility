local PED = {}
local OBJECT = {}
local VEHICLE = {}




function LGF:CreateEntityPed(data)
    local model = data.model
    local position = data.position
    local scenario = data.scenario or nil
    local freeze = data.freeze or false
    local isNetworked = data.isNetworked or false
    local invincible = data.invincible or true
    local blockingEvents = data.blockingEvents or true

    local loaded, modelHash = self:RequestEntityModel(model, 3000)
    if not loaded then return end

    local createdPed = CreatePed(4, modelHash, position.x, position.y, position.z - 1, position.w or 0.0, isNetworked, true)
    if scenario then
        TaskStartScenarioInPlace(createdPed, scenario, -1, true)
    end

    SetEntityInvincible(createdPed, invincible)
    SetBlockingOfNonTemporaryEvents(createdPed, blockingEvents)

    NetworkRegisterEntityAsNetworked(createdPed)
    SetEntityAsMissionEntity(createdPed, true, true)
    local NETID = NetworkGetNetworkIdFromEntity(createdPed)

    if freeze then
        FreezeEntityPosition(createdPed, freeze)
    end

    PED[NETID] = {
        EntityID = createdPed,
        EntityHash = modelHash,
        netid = NETID,
        coords = position,
        created = true,
    }

    SetModelAsNoLongerNeeded(modelHash)

    return createdPed
end

function LGF:CreateEntityObject(data)
    local model = data.model
    local position = data.position
    local isNetworked = data.isNetworked or false
    local freeze = data.freeze or false
    local missionEntity = data.missionEntity or false

    local loaded, modelHash = self:RequestEntityModel(model, 3000)
    if not loaded then return end

    local createdObject = CreateObject(modelHash, position.x, position.y, position.z, isNetworked, missionEntity, false)
    SetEntityHeading(createdObject, position.w)
    PlaceObjectOnGroundProperly(createdObject)
    SetModelAsNoLongerNeeded(modelHash)
    NetworkRegisterEntityAsNetworked(createdObject)
    local NETID = NetworkGetNetworkIdFromEntity(createdObject)

    if freeze then
        FreezeEntityPosition(createdObject, freeze)
    end

    OBJECT[NETID] = {
        EntityID = createdObject,
        EntityHash = modelHash,
        netid = NETID,
        coords = position,
        created = true,
    }

    return createdObject
end

function LGF:CreateEntityVehicle(data)
    local PROM = promise.new()
    local model = data.model
    local position = data.position
    local isNetworked = data.isNetworked or false
    local seatPed = data.seatPed or false
    local seat = data.seat or -1
    local freeze = data.freeze or false

    local loaded, modelHash = self:RequestEntityModel(model, 3000)
    if not loaded then
        PROM:reject("Failed to load model")
        return Citizen.Await(PROM)
    end

    local createdVehicle = CreateVehicle(modelHash, position.x, position.y, position.z, position.w, isNetworked, false)
    SetVehicleOnGroundProperly(createdVehicle)
    SetModelAsNoLongerNeeded(modelHash)
    NetworkRegisterEntityAsNetworked(createdVehicle)
    SetVehicleHasBeenOwnedByPlayer(createdVehicle, true)
    local NETID = NetworkGetNetworkIdFromEntity(createdVehicle)
    SetNetworkIdCanMigrate(NETID, true)

    if seatPed then
        TaskWarpPedIntoVehicle(PlayerPedId(), createdVehicle, seat)
    end

    if freeze then
        FreezeEntityPosition(createdVehicle, freeze)
    end

    VEHICLE[NETID] = {
        EntityID = createdVehicle,
        EntityHash = modelHash,
        netid = NETID,
        coords = position,
        created = true,
    }

    PROM:resolve(createdVehicle)

    if data.onCreated then
        data.onCreated(createdVehicle)
    end

    return Citizen.Await(PROM)
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, entity in pairs(PED) do
            if DoesEntityExist(entity.EntityID) then
                DeleteEntity(entity.EntityID)
            end
        end
        for _, entity in pairs(OBJECT) do
            if DoesEntityExist(entity.EntityID) then
                DeleteEntity(entity.EntityID)
            end
        end
        for _, entity in pairs(VEHICLE) do
            if DoesEntityExist(entity.EntityID) then
                DeleteEntity(entity.EntityID)
            end
        end
    end
end)


function LGF:GetAllEntityPed()
    local peds = {}
    for _, data in pairs(PED) do
        table.insert(peds, data)
    end
    return peds
end

function LGF:GetAllEntityObjects()
    local objects = {}
    for _, data in pairs(OBJECT) do
        table.insert(objects, data)
    end
    return objects
end

function LGF:GetAllEntityVehicles()
    local vehicles = {}
    for _, data in pairs(VEHICLE) do
        table.insert(vehicles, data)
    end
    return vehicles
end

exports("CreateEntityPed", function(data) return LGF:CreateEntityPed(data) end)
exports("CreateEntityObject", function(data) return LGF:CreateEntityObject(data) end)
exports("CreateEntityVehicle", function(data) return LGF:CreateEntityVehicle(data) end)
exports("GetAllEntityPed", function() return LGF:GetAllEntityPed() end)
exports("GetAllEntityObjects", function() return LGF:GetAllEntityObjects() end)
exports("GetAllEntityVehicles", function() return LGF:GetAllEntityVehicles() end)
