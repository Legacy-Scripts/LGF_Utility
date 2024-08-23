InputMetaTable = {}
InputMetaTable.__index = InputMetaTable
local INPUT_FIELDS = {}
local CB = nil
function InputMetaTable.new(inputID, inputTitle, fields, canClose)
    local self = setmetatable({}, InputMetaTable)
    self.id = inputID
    self.title = inputTitle
    self.fields = fields
    self.canClose = canClose
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
    local Focused = IsNuiFocused()
    SetNuiFocus(not Focused, not Focused)
    local inputData = INPUT_FIELDS[inputID]
    if inputData then
        sendNuiMessage("showInputForm", {
            id = inputData.id,
            title = inputData.title,
            fields = inputData.fields,
            canClose = inputData.canClose
        })
    end
end


local function closeInputForm(inputID)
    local Focused = IsNuiFocused()
    if Focused then
        SetNuiFocus(false, false)
    end
    local inputData = INPUT_FIELDS[inputID]
    if inputData then
        sendNuiMessage("closeInputForm", {
            id = inputData.id,
        })
    end
end

RegisterNuiCallback('input:Close', function(data, cb)
    cb('ok')
    Wait(500)
    closeInputForm(data.inputID)
    CB:resolve(nil)
end)

local function registerInput(inputID, inputTitle, fields, canClose)
    CB = promise.new()
    if not inputID or not inputTitle or not fields then
        print(('Error: Missing data in registerInput. InputID: %s, InputTitle: %s, Fields: %s'):format(
            tostring(inputID or "nil"),
            tostring(inputTitle or "nil"),
            tostring(fields or "nil")
        ))
        return
    end

    INPUT_FIELDS[inputID] = InputMetaTable.new(inputID, inputTitle, fields, canClose)
    print('Registered input:', inputID, inputTitle)
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
            canClose = inputData.canClose
        })
    else
        cb(nil)
    end
end)


local function logFieldSubmission(data)
    for index, value in pairs(data) do
        print("Field index:", index, "Value:", value)
    end
end

RegisterNuiCallback('input:Submit', function(data, cb)
    local input = INPUT_FIELDS[data.inputID]
    if input then
        local success = input:submitFields(data.fields)
        logFieldSubmission(data.fields)

        cb(success)
        Wait(1500)
        local Focused = IsNuiFocused()
        if Focused then
            SetNuiFocus(false, false)
        end
        CB:resolve(true)
    else
        cb(false)
    end
end)
exports('RegisterInput', registerInput)

RegisterCommand('input', function()
    local inputData = {}
    local negro = exports['LGF_UI']:RegisterInput('player_info', 'Player Information', {
        {
            label = 'Enter your name:',
            placeholder = 'Name',
            description = 'Please enter your full name.',
            type = 'text',
            required = true,
            onSubmit = function(value)
                inputData.name = value
            end
        },
        {
            label = 'Select your class:',
            type = 'select',
            options = {
                { label = 'Warrior', value = 'warrior' },
                { label = 'Mage',    value = 'mage' },
                { label = 'Rogue',   value = 'rogue' }
            },
            description = 'Choose your class from the options provided.',
            required = true,
            onSubmit = function(value)
                inputData.class = value
            end
        },
    }, true)
    print(negro)
    if negro then
        print('dwadwadwadwadwa')
        print(json.encode(inputData))
        TriggerServerEvent('SendInputData', inputData)
    end
end)
