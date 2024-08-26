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




exports("RequestEntityModel", function(model, timeout) return LGF:RequestEntityModel(model, timeout) end)
