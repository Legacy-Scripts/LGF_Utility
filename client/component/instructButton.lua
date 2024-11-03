local Instruct = {}
LocalPlayer.state.instructOpened = false

local function sendNuiMessage(action, data)
    LocalPlayer.state.instructOpened = data.visible
    SendNUIMessage({
        action = action,
        data = data
    })
end

local Cached = {}

local function handleKeyBindPressed(keyBind)
    if Cached.onBindPressed then
        Cached.onBindPressed(keyBind)
    end
end

local function handleKeyBindReleased(keyBind)
    if Cached.onBindPressed then
        Cached.onBindReleased(keyBind)
    end
end


local function loop(controls)
    while LocalPlayer.state.instructOpened do
        Wait(0)
        for _, control in pairs(controls) do
            if IsControlJustPressed(0, control.indexKey) then
                handleKeyBindPressed(control.indexKey)
            end
            if IsControlJustReleased(0, control.indexKey) then
                handleKeyBindReleased(control.indexKey)
            end
        end
    end
end

function Instruct.OpenControlInstructional(data)
    if data.Visible then
        Cached = data
        sendNuiMessage("openInstructionalButt", {
            visible = true,
            controls = data.Controls or {},
            schema = data.Schema or {
                Styles = {}
            },
        })

        CreateThread(function()
            loop(data.Controls)
        end)
    else
        sendNuiMessage("openInstructionalButt", {
            visible = false,
            controls = Cached.Controls or {},
            schema = Cached.Schema
        })
    end
end

function Instruct.CloseControlInstructional()
    Instruct.OpenControlInstructional({
        Visible = false
    })
end

exports("interactionButton", Instruct.OpenControlInstructional)
exports("closeInteraction", Instruct.CloseControlInstructional)
exports("getStateInteraction", function() return LocalPlayer.state.instructOpened end)

return Instruct
