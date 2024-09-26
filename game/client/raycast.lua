LGF.RaycastHandler = {}

function LGF.RaycastHandler:drawLine(startPosition, endPosition, lineColor)
    DrawLine(startPosition.x, startPosition.y, startPosition.z, endPosition.x, endPosition.y, endPosition.z, lineColor.r,
        lineColor.g, lineColor.b, lineColor.a)
end

local function getDirectionFromCameraRotation(cameraRotation)
    local radians = { x = math.rad(cameraRotation.x), y = math.rad(cameraRotation.y), z = math.rad(cameraRotation.z) }
    return { x = -math.sin(radians.z) * math.abs(math.cos(radians.x)),y = math.cos(radians.z) * math.abs(math.cos(radians.x)), z = math.sin(radians.x) }
end

function LGF.RaycastHandler:performRaycast(maxDistance, drawMarker, drawLine)
    local playerPed = PlayerPedId()
    local chestBoneIndex = GetPedBoneIndex(playerPed, 0x796e)
    local chestPosition = GetWorldPositionOfEntityBone(playerPed, chestBoneIndex)
    local direction = getDirectionFromCameraRotation(GetGameplayCamRot())

    local raycastDestination = {
        x = chestPosition.x + direction.x * maxDistance,
        y = chestPosition.y + direction.y * maxDistance,
        z = chestPosition.z + direction.z * maxDistance
    }

    local rayHandle = StartShapeTestRay(chestPosition.x, chestPosition.y, chestPosition.z, raycastDestination.x,
        raycastDestination.y, raycastDestination.z, -1, playerPed, 0)
    local success, hit, hitCoordinates, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local lineColor, markerColor
    if hit and (IsEntityAVehicle(entityHit) or IsEntityAPed(entityHit) or IsEntityAnObject(entityHit)) then
        lineColor = { r = 255, g = 0, b = 0, a = 255 }
        markerColor = { r = 255, g = 0, b = 0, a = 100 }

        if drawMarker then
            DrawMarker(28, hitCoordinates.x, hitCoordinates.y, hitCoordinates.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1,
                0.1, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, nil, nil, false)
        end

        if drawLine then
            self:drawLine(chestPosition, hitCoordinates, lineColor)
        end

        return hit, entityHit, hitCoordinates, surfaceNormal
    end

    lineColor = { r = 0, g = 255, b = 0, a = 255 }
    if drawLine then
        self:drawLine(chestPosition, raycastDestination, lineColor)
    end
    return false, nil, raycastDestination, nil
end


function LGF.RaycastHandler:performTargetPlayer(distanceMax, markerType, drawLine)
    local playerPed = LGF.Player:Ped()
    local players = GetActivePlayers()
    local closestPlayer, closestDistance = nil, 9999.0

    for _, player in ipairs(players) do
        if player ~= LGF.Player:PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetPosition = GetEntityCoords(targetPed)
            local distance = Vdist(GetEntityCoords(playerPed), targetPosition)

            if distance < closestDistance and distance < distanceMax then
                closestDistance = distance
                closestPlayer = targetPed
            end
        end
    end

    if closestPlayer then
        local hit, entityHit, hitCoordinates = LGF.RaycastHandler:performRaycast(distanceMax, false, drawLine)

        if hit and entityHit == closestPlayer then
            local markerPosition = { x = GetEntityCoords(closestPlayer).x, y = GetEntityCoords(closestPlayer).y, z = GetEntityCoords(closestPlayer).z + 1.5 }
            DrawMarker(markerType, markerPosition.x, markerPosition.y, markerPosition.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 1.5, 0.5, 255, 128, 0, 50, true, true, 2, nil, nil, false)
            return GetEntityCoords(closestPlayer), closestPlayer, GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPlayer))
        end
    end

    return nil, nil, nil
end
