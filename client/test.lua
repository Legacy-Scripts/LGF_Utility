--[[REFERENCE TABLE WITH VEHICLE FOR CONTEXT]]
local Vehicle = {
    { model = 'kuruma',   Label = 'Kuruma',    Fuel = 24, color = 'Black',  type = 'Sedan',    maxSpeed = 120 },
    { model = 'sultan',   Label = 'Sultan',    Fuel = 54, color = 'Silver', type = 'Sport',    maxSpeed = 150 },
    { model = 'infernus', Label = 'Infernus',  Fuel = 34, color = 'Red',    type = 'Super',    maxSpeed = 220 },
    { model = 'comet',    Label = 'Comet',     Fuel = 74, color = 'Blue',   type = 'Sport',    maxSpeed = 180 },
    { model = 'felon',    Label = 'Felon',     Fuel = 24, color = 'Green',  type = 'Coupe',    maxSpeed = 160 },
    { model = 't20',      Label = 'T20',       Fuel = 54, color = 'Yellow', type = 'Super',    maxSpeed = 230 },
    { model = 'voltic',   Label = 'Voltic',    Fuel = 34, color = 'White',  type = 'Electric', maxSpeed = 140 },
    { model = 'banshee',  Label = 'Banshee',   Fuel = 74, color = 'Gray',   type = 'Sport',    maxSpeed = 200 },
    { model = 'turismor', Label = 'Turismo R', Fuel = 24, color = 'Purple', type = 'Super',    maxSpeed = 250 },
    { model = 'ztype',    Label = 'Z-Type',    Fuel = 54, color = 'Orange', type = 'Classic',  maxSpeed = 170 },
    { model = 'exemplar', Label = 'Exemplar',  Fuel = 34, color = 'Brown',  type = 'Coupe',    maxSpeed = 180 },
    { model = 'osiris',   Label = 'Osiris',    Fuel = 74, color = 'Pink',   type = 'Super',    maxSpeed = 240 },
}


local function CreateVehicleTest(vehicleModel)
    print("Creating vehicle with model:", vehicleModel)
    local ModelHash = vehicleModel
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Wait(0)
    end
    local MyPed = PlayerPedId()
    local Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), true, false)
    SetModelAsNoLongerNeeded(ModelHash)
    TaskWarpPedIntoVehicle(MyPed, Vehicle, -1)
end



local function GenerateVehicleMenu(vehicle)
    local MenuID = 'vehicle_menu_' .. vehicle.Label
    local TITLE = vehicle.Label
    exports['LGF_UI']:RegisterContextMenu(MenuID, TITLE, {
        {
            labelButton = "Spawn",
            label = "Spawn Vehicle",
            description = vehicle.Label,
            icon = 'arrow-up',

            onSelect = function()
                CreateVehicleTest(vehicle.model)
                exports['LGF_UI']:CloseContext(MenuID)
            end
        },
        {
            labelButton = "Refuel",
            label = "Refuel Vehicle",
            description = vehicle.Label,
            icon = 'gas-pump',
            onSelect = function()
                print('Refueling vehicle: ' .. vehicle.Label)
            end
        },
        {
            labelButton = "Back",
            label = "Back to Main Menu",
            icon = 'arrow-left',
            onSelect = function()
                GenerateMainMenu()
            end
        }
    })
    exports['LGF_UI']:ShowContextMenu(MenuID, true)
end

function GenerateMainMenu()
    local options = {}
    for i = 1, #Vehicle do
        local v = Vehicle[i]
        local disabled = v.Fuel <= 60
        table.insert(options, {
            label = v.Label,

            description = 'Fuel: ' .. v.Fuel .. '%',
            icon = 'car',
            disabled = disabled,
            progress = v.Fuel,
            colorProgress = 'green',
            labelButton = 'Select',
            metadata = {
                title         = "Vehicle Details",
                iconTitle     = 'car',
                metadataValue = {
                    fuel     = v.Fuel,
                    color    = v.color,
                    maxSpeed = v.maxSpeed,
                    caca     = "Example Data",
                    tititi   = "Example Data",
                    lolol    = "Example Data"
                }
            },
            onSelect = function()
                GenerateVehicleMenu(v)
            end
        })
    end

    exports['LGF_UI']:RegisterContextMenu('main_menu', 'Select Vehicle', options)
    exports['LGF_UI']:ShowContextMenu('main_menu', true)
end

exports.ox_target:addGlobalVehicle({
    {

        icon = 'fa-solid fa-car',
        label = 'Debug Vehicle',
        onSelect = function()
            if not exports['LGF_UI']:CanOpenContext() then return end
            GenerateMainMenu()
        end
    },
})



-- [[DIALOG AND TEXT UI]]

local point = lib.points.new({
    coords = vec3(-1220.5801, -805.1790, 16.6298),
    distance = 5,
    dunak = 'nerd',
})

function point:onEnter()
    exports['LGF_UI']:OpenTextUI({
        message = "[E] - OPEN LIFE STYLE SELECTOR",
        position = "center-right",
        useKeybind = false,
        keyBind = "E",
        useProgress = true,
    })
end

function point:onExit()
    TEXTUI:HideTextUI()
end

function point:nearby()
    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20,
        50, false, true, 2, false, nil, nil, false)

    if self.currentDistance < 3 and IsControlJustReleased(0, 38) then
        OpenDialogTest()
        exports['LGF_UI']:CloseTextUI()
    end
end

local LifeStyle = {
    Criminal = {
        ['water'] = 3,
        ['WEAPON_PISTOL'] = 1,
        ['burger'] = 3,
    },
    Police = {
        ['bandage'] = 1,
        ['water'] = 2,
        ['radio'] = 1,
    },
    Civilian = {
        ['burger'] = 2,
        ['sprunk'] = 2,
        ['water'] = 2,
    },
    Medical = {
        ['bandage'] = 5,
        ['water'] = 3,
        ['sprunk'] = 2,
    }
}

function OpenDialogTest()
    exports['LGF_UI']:RegisterDialog({
        id = 'lifeStyle',
        title = 'Life Style',
        enableCam = true,
        cards = {
            {
                title = 'Criminal',
                message =
                'The criminal lifestyle is characterized by activities outside the law. Those who choose this path often engage in illegal activities such as theft, smuggling, and various forms of organized crime. Embracing a criminal life typically involves high risks and the need for secrecy. If you are interested in acquiring items associated with this lifestyle, you will be provided with resources that may assist you in navigating and thriving within this world of crime. Choose wisely, as each decision has its consequences.',
                actionLabel = 'Criminal',
                image =
                "https://cdn.discordapp.com/attachments/1273666294599913524/1273668480801177622/thumb-1920-1343705.png?ex=66c410f5&is=66c2bf75&hm=bba586457be139e24bfed0fe4b1004de17b50cda885f20c3bccc6ebaa114aa6c&",
                onAction = function()
                    local items = LifeStyle.Criminal
                    print('Criminal Life Selected')
                    for item, amount in pairs(items) do
                        TriggerServerEvent('LGF_UI:Test:GetStyleItems', item, amount)
                    end
                    exports['LGF_UI']:CloseDialog("lifeStyle")
                end,
            },
            {
                title = 'Police',
                message =
                'The police lifestyle involves upholding the law and maintaining public safety. As a police officer, you are tasked with enforcing laws, investigating crimes, and protecting citizens. This role requires integrity, courage, and a strong commitment to justice. By selecting this lifestyle, you will receive items that support your duties in law enforcement, including tools and equipment essential for your role in ensuring peace and order within the community.',
                actionLabel = 'Police',
                onAction = function()
                    print('Police Life Selected')
                    local items = LifeStyle.Police
                    for item, amount in pairs(items) do
                        TriggerServerEvent('LGF_UI:Test:GetStyleItems', item, amount)
                    end
                    exports['LGF_UI']:CloseDialog("lifeStyle")
                end,
            },
            {
                title = 'Civilian',
                message =
                'The civilian lifestyle is centered around everyday life outside of specialized roles such as criminal or police work. Civilians live and work in their communities, contributing to society in various ways. This lifestyle is marked by a focus on personal and professional growth within a non-law enforcement or criminal context. By choosing this option, you will gain access to items that enhance your experience in a typical civilian role, helping you in your daily activities and interactions.',
                actionLabel = 'Civilian',
                onAction = function()
                    local items = LifeStyle.Civilian
                    print('Civilian Life Selected')
                    for item, amount in pairs(items) do
                        TriggerServerEvent('LGF_UI:Test:GetStyleItems', item, amount)
                    end
                    exports['LGF_UI']:CloseDialog("lifeStyle")
                end,
            },
            {
                title = 'Medical',
                message =
                'The medical lifestyle focuses on health and emergency care. Individuals in this role are dedicated to diagnosing, treating, and caring for patients in various medical settings. Whether working in hospitals, clinics, or emergency services, medical professionals play a crucial role in maintaining public health and providing critical care. By choosing the medical lifestyle, you will receive items and resources that are essential for performing medical duties and supporting your role in healthcare.',
                actionLabel = 'Medic',
                onAction = function()
                    print('Medical Life Selected')
                    local items = LifeStyle.Medical
                    for item, amount in pairs(items) do
                        TriggerServerEvent('LGF_UI:Test:GetStyleItems', item, amount)
                    end
                    exports['LGF_UI']:CloseDialog("lifeStyle")
                end,
            }

        }
    })
end

RegisterCommand('testNotifications', function()
    -- Notification 1: Success
    TriggerEvent('LGF_UI:SendNotification', {
        id = "success1",
        title = "Success",
        message = "Operation completed successfully.",
        icon = "success",
        duration = 3000,
        position = 'top-right'
    })

    -- Notification 2: Error
    TriggerEvent('LGF_UI:SendNotification', {
        id = "error1",
        title = "Error",
        message = "An error occurred during the operation.",
        icon = "error",
        duration = 3000,
        position = 'top-left'
    })

    -- Notification 3: Progress
    TriggerEvent('LGF_UI:SendNotification', {
        id = "progress1",
        title = "Processing",
        message = "Your request is being processed.",
        icon = "progress",
        duration = 5000,
        position = 'bottom-right'
    })

    -- Notification 4: Line
    TriggerEvent('LGF_UI:SendNotification', {
        id = "line1",
        title = "Update Available",
        message = "A new update is available. Please download it.",
        icon = "line",
        duration = 4000,
        position = 'bottom-left'
    })

    -- Notification 5: Custom
    TriggerEvent('LGF_UI:SendNotification', {
        id = "custom1",
        title = "Welcome",
        message = "Welcome to the server! Have a great time.",
        icon = "success",
        duration = 4000,
        position = 'top-right'
    })
end)
