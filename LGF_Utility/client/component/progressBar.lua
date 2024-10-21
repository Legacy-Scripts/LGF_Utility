PROGRESS = {}
PROGRESSOPENED = false
LocalPlayer.state.progressOpen = false
local disabledControls = {}

function delay(ms)
    local co = coroutine.running()
    Citizen.SetTimeout(ms, function()
        coroutine.resume(co)
    end)
    return coroutine.yield()
end

function PROGRESS:CreateProgress(data)
    if _G.isUIOpen then return end
    local message = data.message
    local colorProgress = data.colorProgress or "rgba(54, 156, 129, 0.381)"
    local position = data.position or "center"
    local duration = data.duration or 5000
    local transition = data.transition or "fade"
    local typeBar = "linear"
    local onFinish = data.onFinish
    local disableBind = data.disableBind
    local disableKeyBind = data.disableKeyBind or {}


    SendNUIMessage({
        action = "showProgressBar",
        message = message,
        colorProgress = colorProgress,
        position = position,
        duration = duration,
        transition = transition,
        typeBar = typeBar
    })

    LocalPlayer.state.progressOpen = true
    _G.isUIOpen = true

    CreateThread(function()
        local startTime = GetGameTimer()

        while LocalPlayer.state.progressOpen do
            Wait(0)

            for _, key in ipairs(disableKeyBind) do
                DisableControlAction(0, key, true)
                disabledControls[key] = true
            end


            if disableBind and IsControlJustPressed(0, disableBind) then
                PROGRESS:DisableProgressBar()
                return
            end


            if GetGameTimer() - startTime >= duration then
                delay(200)
                PROGRESS:DisableProgressBar()
                if onFinish then
                    onFinish()
                end
                return
            end
        end
    end)
end

function PROGRESS:DisableProgressBar()
    SendNUIMessage({ action = "hideProgressBar" })
    LocalPlayer.state.progressOpen = false
    _G.isUIOpen = false
    for key, _ in pairs(disabledControls) do
        EnableControlAction(0, key, true)
    end

    disabledControls = {}
end

AddEventHandler('onResourceStop', function(res)
    if not res == "LGF_UI" then return end
    if LocalPlayer.state.progressOpen then
        PROGRESS:DisableProgressBar()
    end

    if TEXTUI:GetStateTextUI() then
        TEXTUI:HideTextUI()
    end
end)

exports('DisableProgressBar', function() return PROGRESS:DisableProgressBar() end)
exports('CreateProgressBar', function(data) return PROGRESS:CreateProgress(data) end)
exports('GetStateProgress', function() return LocalPlayer.state.progressOpen end)
