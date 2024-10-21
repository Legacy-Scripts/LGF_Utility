InputMetaTable = {}
InputMetaTable.__index = InputMetaTable
local INPUT_FIELDS = {}
local CB = nil
LocalPlayer.state.InputOpened = false

function InputMetaTable.new(inputID, inputTitle, fields, canClose, titleButton)
    local self = setmetatable({}, InputMetaTable)
    self.id = inputID
    self.title = inputTitle
    self.fields = fields
    self.canClose = canClose
    self.titleButton = titleButton
    return self
end

function InputMetaTable:getField(index)
    return self.fields[index]
end

function InputMetaTable:submitFields(data)
    local fieldValues = {}

    for index, field in ipairs(self.fields) do
        local value = data[index] or ""
        fieldValues[field.label] = value
        if field.onSubmit then
            field.onSubmit(value)
        end
    end

    return fieldValues
end

local function sendNuiMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function showInputForm(inputID)
    -- if _G.isUIOpen then return end
    local Focused = IsNuiFocused()
    SetNuiFocus(not Focused, not Focused)
    local inputData = INPUT_FIELDS[inputID]
    if inputData then
        sendNuiMessage("showInputForm", {
            id = inputData.id,
            title = inputData.title,
            fields = inputData.fields,
            canClose = inputData.canClose,
            titleButton = inputData.titleButton,
        })
        LocalPlayer.state.InputOpened = true
        _G.isUIOpen = true
    end
end


local function closeInputForm(inputID)
    local inputData = INPUT_FIELDS[inputID]
    if inputData then
        local Focused = IsNuiFocused()
        if Focused then
            SetNuiFocus(false, false)
        end
        sendNuiMessage("closeInputForm", {
            id = inputData.id,
        })
        LocalPlayer.state.InputOpened = false
        _G.isUIOpen = false
    else
        print(('Error: Input ID %s not found in INPUT_FIELDS. Available IDs: %s'):format(inputID,
            json.encode(INPUT_FIELDS, { indent = true })))
    end
end

RegisterNuiCallback('input:Close', function(data, cb)
    cb('ok')
    closeInputForm(data.inputID)
    CB:resolve(nil)
    LocalPlayer.state.InputOpened = false
    _G.isUIOpen = false
end)

local function registerInput(inputID, inputTitle, fields, canClose, titleButton)
    CB = promise.new()
    if not inputID or not inputTitle or not fields then
        print(('Error: Missing data in registerInput. InputID: %s, InputTitle: %s, Fields: %s'):format(
            tostring(inputID or "nil"),
            tostring(inputTitle or "nil"),
            tostring(fields or "nil")
        ))
        return
    end

    INPUT_FIELDS[inputID] = InputMetaTable.new(inputID, inputTitle, fields, canClose, titleButton)
    showInputForm(inputID)
    return Citizen.Await(CB)
end

RegisterNuiCallback('LGF_UI.GetInputData', function(data, cb)
    local inputID = data.inputID
    local inputData = INPUT_FIELDS[inputID]
    if inputData then
        cb({
            id = inputData.id,
            title = inputData.title,
            fields = inputData.fields,
            canClose = inputData.canClose,
            titleButton = inputData.titleButton,
        })
    else
        cb(nil)
    end
end)

RegisterNuiCallback('input:Submit', function(data, cb)
    local input = INPUT_FIELDS[data.inputID]
    if input then
        local success = input:submitFields(data.fields)
        local Focused = IsNuiFocused()
        if Focused then
            SetNuiFocus(false, false)
        end
        cb(success)
        CB:resolve(true)
    else
        cb(false)
    end
end)

local function GetInputState()
    return LocalPlayer.state.InputOpened
end

local function ForceCloseInput()
    closeInputForm(nil)
    LocalPlayer.state.InputOpened = false
end


exports('RegisterInput', registerInput)
exports('CloseInput', closeInputForm)
exports('ShowInput', showInputForm)
exports('GetInputState', GetInputState)
exports('ForceCloseInput', ForceCloseInput)
