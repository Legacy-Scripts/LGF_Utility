---@class DialogCard
---@field title string Title of the card
---@field message string Message or description associated with the card
---@field actionLabel string|nil Label for the action button (optional)
---@field actionCloseLabel string|nil Label for the close action button (optional, default is "Close")
---@field onAction function|nil Function callback triggered when the action button is pressed (optional)
---@field onClose function|nil Function callback triggered when the dialog is closed (optional)
---@field image string|nil URL or path to an image to be displayed on the card (optional)

---@class DialogData
---@field id string Unique ID for the dialog
---@field title string Title of the dialog
---@field enableCam boolean Whether to enable the custom camera when the dialog is opened
---@field cards DialogCard[] Array of card objects that represent options or content within the dialog


DialogMetaTable = {}
DialogMetaTable.__index = DialogMetaTable
local DIALOGS = {}
local currentCam
LocalPlayer.state.DialogOpened = false

function CameraDialog()
    local entity = PlayerPedId()
    local distance = 1.0
    local entityCoords = GetOffsetFromEntityInWorldCoords(entity, 0, distance, 0)

    local ENTITYCOORDSCAM = vector3(entityCoords.x, entityCoords.y, entityCoords.z + 0.90)
    local defaultCamRot = vector3(-24.0, 0.0, GetEntityHeading(entity) + 180)
    local defaultCamZoom = 100.0

    if currentCam then
        SetCamActive(currentCam, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(currentCam)
    end

    currentCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(currentCam, ENTITYCOORDSCAM)
    SetCamRot(currentCam, defaultCamRot.x, defaultCamRot.y, defaultCamRot.z, 2)
    SetCamFov(currentCam, defaultCamZoom)

    SetCamActive(currentCam, true)
    RenderScriptCams(true, true, 2000, true, true)
    SetFocusArea(ENTITYCOORDSCAM, 0.0, 0.0, 0.0)
    SetFocusEntity(entity)
end

function DestroyCamera()
    if currentCam then
        RenderScriptCams(false, true, 2000, 1, 0)
        DestroyCam(currentCam, false)
        currentCam = nil
    end
end

function DialogMetaTable.new(dialogID, dialogTitle, cards)
    local self = setmetatable({}, DialogMetaTable)
    self.id = dialogID
    self.title = dialogTitle
    self.cards = cards
    return self
end

function DialogMetaTable:getCard(index)
    return self.cards[index]
end

function DialogMetaTable:handleAction(cardIndex)
    print(cardIndex)
    local card = self:getCard(cardIndex)
    if card and card.onAction then
        card.onAction()
        return true
    end
    return false
end

function DialogMetaTable:handleClose(cardIndex)
    local card = self:getCard(cardIndex)
    if card then
        if card.onClose then
            card.onClose()
            return true
        end
    else
        print(('Card not found for cardIndex: %s'):format(cardIndex))
    end
    return false
end

local function registerDialog(dialogID, dialogTitle, cards)
    if not dialogID or not dialogTitle or not cards then
        print(('Error: Missing data in registerDialog. DialogID: %s, DialogTitle: %s, Cards: %s'):format(
            tostring(dialogID or "nil"),
            tostring(dialogTitle or "nil"),
            tostring(cards or "nil")
        ))
        return
    end

    DIALOGS[dialogID] = DialogMetaTable.new(dialogID, dialogTitle, cards)
end

function OpenDialog(data)

    SetNuiFocus(true, true)
    local dialogID = data.id
    registerDialog(dialogID, data.title, data.cards or {})

    if data.enableCam then
        CameraDialog()
    end

    local CARDS_STEPPER = {}
    for _, card in ipairs(data.cards or {}) do
        local cardCopy = {}
        for key, value in pairs(card) do
            if key ~= 'onAction' and key ~= 'onClose' then
                cardCopy[key] = value
            end
        end

        cardCopy.hasOnAction = card.onAction ~= nil
        cardCopy.hasOnClose = card.onClose ~= nil
        table.insert(CARDS_STEPPER, cardCopy)
    end

    SendNUIMessage({
        action = 'showDialog',
        id = dialogID,
        title = data.title,
        cards = CARDS_STEPPER
    })

    LocalPlayer.state.DialogOpened = true
    _G.isUIOpen = true
end

function CloseDialog(dialogID)
    if currentCam then
        DestroyCamera()
    end
    SetNuiFocus(false, false)
    DIALOGS[dialogID] = nil
    SendNUIMessage({
        action = 'hideDialog',
        id = dialogID
    })
    LocalPlayer.state.DialogOpened = false
    _G.isUIOpen = false
end

RegisterNUICallback('dialogAction', function(data, cb)
    local dialog = DIALOGS[data.id]
    if dialog then
        local success = dialog:handleAction(data.cardIndex)
        if success then
            cb('ok')
        else
            cb('error')
        end
    else
        cb('error')
    end
end)

RegisterNUICallback('dialogClose', function(data, cb)
    if currentCam then
        DestroyCamera()
    end
    SetNuiFocus(false, false)
    local dialog = DIALOGS[data.id]
    if dialog then
        local success = dialog:handleClose(data.cardIndex)
        if success then
            cb('ok')
            LocalPlayer.state.DialogOpened = false
            _G.isUIOpen = false
        else
            cb('error')
        end
    else
        cb('error')
    end
end)


local function GetStateDialog()
    return LocalPlayer.state.DialogOpened
end

exports('RegisterDialog', function(data)
    print("dwadwadwa")
    _G.isUIOpen = true
    return OpenDialog(data)
end)

exports('CloseDialog', function(dialogID)
    _G.isUIOpen = false
    return CloseDialog(dialogID)
end)

exports('GetDialogState', GetStateDialog)

--[[
    exports['LGF_UI']:RegisterDialog(data)
    exports['LGF_UI']:CloseDialog(dialogID)
    exports['LGF_UI']:GetDialogState()
]]
