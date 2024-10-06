TEXTUI = {}

LocalPlayer.state.textUiOpen = false

---@class TextUIData
---@field title string The title of the Text UI (optional)
---@field message string The message to display
---@field colorProgress string Progress color (optional)
---@field keyBind string Keybind to display (optional, only if useKeybind is true also show the loader)
---@field position string Position of the UI (e.g., "center", "center-left", "center-right")
---@field useKeybind boolean Show the keybind (optional)
---@field useProgress boolean Show the loader (optional)

---@param data TextUIData
function TEXTUI:OpenTextUI(data)
    local message = data.message
    local colorProgress = data.colorProgress or "rgba(54, 156, 129, 0.381)"
    local keyBind = data.keyBind or ""
    local position = data.position or "center-right"
    local useKeybind = data.useKeybind or false
    local useProgress = data.useProgress or false
    local title = data.title

    SendNUIMessage({
        action = "showTextUI",
        title = title,
        message = message,
        colorProgress = useProgress and colorProgress or nil,
        keyBind = useKeybind and keyBind or nil,
        position = position,
        useKeybind = useKeybind,
        useProgress = useProgress
    })

    LocalPlayer.state.textUiOpen = true
    _G.isUIOpen = true
end

function TEXTUI:HideTextUI()
    SendNUIMessage({ action = "hideTextUI" })
    LocalPlayer.state.textUiOpen = false
    _G.isUIOpen = false
end

function TEXTUI:GetStateTextUI()
    return LocalPlayer.state.textUiOpen
end

exports('OpenTextUI', function(data)
    TEXTUI:OpenTextUI(data)
    _G.isUIOpen = true
end)

exports('GetStateTextUI', function()
    return TEXTUI:GetStateTextUI()
end)

exports('CloseTextUI', function()
    return TEXTUI:HideTextUI()
end)


