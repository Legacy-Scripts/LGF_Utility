local vehicleCache = {
    vehicle = nil,
    seat = nil,
    plate = nil,
    fuel = nil,
}


local function updateVehicleCache(key, value)
    if value ~= vehicleCache[key] then
        TriggerEvent(('LGF_Utility:Cache:%s'):format(key), value, vehicleCache[key])
        vehicleCache[key] = value
    end
end

function LGF:getCache(key)
    if not key then return warn("missing Key") end
    return vehicleCache[key]
end

function PedIsInVehicle()
    local playerPed = LGF.Player:Ped()
    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
    if currentVehicle ~= 0 then
        return true, currentVehicle
    else
        return false, nil
    end
end

function GetVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

function MonitorVehicleEvents()
    local previousVehicle = nil
    local previousSeat = nil
    local previousPlate = nil
    local previousFuel = nil

    CreateThread(function()
        while true do
            local isInVehicle, currentVehicle = PedIsInVehicle()
            local currentSeat = -1

            if isInVehicle then
                for i = -1, GetVehicleMaxNumberOfPassengers(currentVehicle) - 1 do
                    if GetPedInVehicleSeat(currentVehicle, i) == LGF.Player:Ped() then
                        currentSeat = i
                        break
                    end
                end

                local currentPlate = GetVehiclePlate(currentVehicle)
                local currentFuel = GetVehicleFuelLevel(currentVehicle)

                if currentVehicle ~= previousVehicle then
                    if previousVehicle then
                        TriggerEvent('LGF_Utility:Vehicle:Exit', previousVehicle, previousSeat)
                    end

                    TriggerEvent('LGF_Utility:Vehicle:Enter', currentVehicle, currentSeat)

                    updateVehicleCache('vehicle', currentVehicle)
                    updateVehicleCache('seat', currentSeat)
                    updateVehicleCache('plate', currentPlate)
                    updateVehicleCache('fuel', currentFuel)

                    previousVehicle = currentVehicle
                    previousSeat = currentSeat
                    previousPlate = currentPlate
                    previousFuel = currentFuel
                else
                    if currentSeat ~= previousSeat then
                        TriggerEvent('LGF_Utility:Vehicle:SeatChange', currentVehicle, currentSeat)
                        updateVehicleCache('seat', currentSeat)
                        previousSeat = currentSeat
                    end

                    if currentPlate ~= previousPlate then
                        updateVehicleCache('plate', currentPlate)
                        previousPlate = currentPlate
                    end

                    if currentFuel ~= previousFuel then
                        updateVehicleCache('fuel', currentFuel)
                        previousFuel = currentFuel
                    end
                end
            else
                if previousVehicle then
                    TriggerEvent('LGF_Utility:Vehicle:Exit', previousVehicle, previousSeat)
                    updateVehicleCache('vehicle', false)
                    updateVehicleCache('seat', false)
                    updateVehicleCache('plate', false)
                    updateVehicleCache('fuel', false)
                    previousVehicle = nil
                    previousSeat = nil
                    previousPlate = nil
                    previousFuel = nil
                end
            end

            Wait(100)
        end
    end)
end

CreateThread(MonitorVehicleEvents)
