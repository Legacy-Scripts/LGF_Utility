-- Vehicle data
local Vehicle = {
    { model = 'kuruma',   Label = 'Kuruma Blindata', Fuel = 24, color = 'Black',  type = 'Sedan',    maxSpeed = 120 },
    { model = 'sultan',   Label = 'Sultan',          Fuel = 54, color = 'Silver', type = 'Sport',    maxSpeed = 150 },
    { model = 'infernus', Label = 'Infernus',        Fuel = 34, color = 'Red',    type = 'Super',    maxSpeed = 220 },
    { model = 'comet',    Label = 'Comet',           Fuel = 74, color = 'Blue',   type = 'Sport',    maxSpeed = 180 },
    { model = 'felon',    Label = 'Felon',           Fuel = 24, color = 'Green',  type = 'Coupe',    maxSpeed = 160 },
    { model = 't20',      Label = 'T20',             Fuel = 54, color = 'Yellow', type = 'Super',    maxSpeed = 230 },
    { model = 'voltic',   Label = 'Voltic',          Fuel = 34, color = 'White',  type = 'Electric', maxSpeed = 140 },
    { model = 'banshee',  Label = 'Banshee',         Fuel = 74, color = 'Gray',   type = 'Sport',    maxSpeed = 200 },
    { model = 'turismor', Label = 'Turismo R',       Fuel = 24, color = 'Purple', type = 'Super',    maxSpeed = 250 },
    { model = 'ztype',    Label = 'Z-Type',          Fuel = 54, color = 'Orange', type = 'Classic',  maxSpeed = 170 },
    { model = 'exemplar', Label = 'Exemplar',        Fuel = 34, color = 'Brown',  type = 'Coupe',    maxSpeed = 180 },
    { model = 'osiris',   Label = 'Osiris',          Fuel = 74, color = 'Pink',   type = 'Super',    maxSpeed = 240 },
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
