function LGF:RequestEntityModel(model, timeout)
    timeout = timeout or 10000

    if not IsModelInCdimage(model) then
        error(("Model %s does not exist or Invalid GameBuild"):format(model), 1)
        return false
    end

    local success, err = pcall(function()
        RequestModel(model)
        local startTime = GetGameTimer()

        while not HasModelLoaded(model) do
            if GetGameTimer() - startTime > timeout then
                error(("Model loading timeout reached for model: %s"):format(model), 2)
            end
            Wait(500)
        end
    end)

    if not success then
        print(("Error loading model: %s"):format(err))
        return false, err
    else
        return true, model
    end
end

function LGF:DrawText3D(data)
    local isOnScreen, screenX, screenY = World3dToScreen2d(data.position.x, data.position.y, data.position.z + 0.5)
    local camX, camY, camZ = table.unpack(GetGameplayCamCoords())
    local distanceScale = (1 / #(vector3(camX, camY, camZ) - data.position)) * 2
    local fovScale = (1 / GetGameplayCamFov()) * 100
    distanceScale = distanceScale * fovScale

    if isOnScreen then
        SetTextScale(0.0, 0.35 * distanceScale)
        SetTextFont(0)
        SetTextProportional(true)
        SetTextColour(data.color[1], data.color[2], data.color[3], data.color[4]) 
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(data.message)
        DrawText(screenX, screenY)
    end
end

exports("DrawText3D", function(data) return LGF:DrawText3D(data) end)

exports("RequestEntityModel", function(model, timeout) return LGF:RequestEntityModel(model, timeout) end)
