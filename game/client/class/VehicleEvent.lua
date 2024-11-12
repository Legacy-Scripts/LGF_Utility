VehicleMonitor = {}
VehicleMonitor.__index = VehicleMonitor

function VehicleMonitor:new()
    local instance = setmetatable({}, VehicleMonitor)
    instance.previousVehicle = nil
    instance.previousSeat = nil
    instance.previousPlate = nil
    instance.isInVehicle = false
    self:startMonitoring(instance)
    return instance
end

function VehicleMonitor:startMonitoring(instance)
    CreateThread(function()
        while true do
            local isInVehicle, currentVehicle = instance:pedIsInVehicle()
            local currentSeat = -1

            if isInVehicle then
                if not instance.isInVehicle then
                    instance.isInVehicle = true
                end

                for i = -1, GetVehicleMaxNumberOfPassengers(currentVehicle) - 1 do
                    if GetPedInVehicleSeat(currentVehicle, i) == LGF.Player:Ped() then
                        currentSeat = i
                        break
                    end
                end

                local currentPlate = GetVehicleNumberPlateText(currentVehicle)
                local currentNetId = NetworkGetNetworkIdFromEntity(currentVehicle)

                if currentVehicle ~= instance.previousVehicle then
                    if instance.previousVehicle then
                        TriggerEvent('LGF_Utility:Vehicle:Exit', instance.previousVehicle, instance.previousSeat,NetworkGetNetworkIdFromEntity(instance.previousVehicle))
                    end
                    TriggerEvent('LGF_Utility:Vehicle:Enter', currentVehicle, currentSeat, currentNetId)
                end

                if currentSeat ~= instance.previousSeat then
                    TriggerEvent('LGF_Utility:Vehicle:SeatChange', currentVehicle, currentSeat, currentNetId)
                end

                instance.previousVehicle = currentVehicle
                instance.previousSeat = currentSeat
                instance.previousPlate = currentPlate
            else
                if instance.previousVehicle then
                    TriggerEvent('LGF_Utility:Vehicle:Exit', instance.previousVehicle, instance.previousSeat,NetworkGetNetworkIdFromEntity(instance.previousVehicle))
                    instance.previousVehicle = nil
                    instance.previousSeat = nil
                    instance.isInVehicle = false
                end
            end

            Wait(1000)
        end
    end)
end

function VehicleMonitor:pedIsInVehicle()
    local playerPed = LGF.Player:Ped()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    return currentVehicle ~= 0, currentVehicle
end

CreateThread(function() VehicleMonitor:new() end)


exports("pedIsInVehicle", function()
    return VehicleMonitor:pedIsInVehicle()
end)
