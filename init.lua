LGF = {}
LGF.Player = {}

function LGF:GetContext()
    local SERVER_SIDE = IsDuplicityVersion()
    local CLIENT_SIDE = not SERVER_SIDE

    if SERVER_SIDE then
        return "server"
    elseif CLIENT_SIDE then
        return "client"
    else
        error("Unable to determine path: Not running on either server or client side")
    end
end

function LGF:LuaLoader(module_name, resource)
    local resource_name = resource or GetInvokingResource()
    local file_name = module_name .. ".lua"
    local file_content = LoadResourceFile(resource_name, file_name)

    if not file_content then
        error(string.format("Error loading file '%s' from resource '%s': File does not exist or cannot be read.",
            file_name, resource_name))
    end

    local func, compile_err = load(file_content, "@" .. file_name)
    if not func then error(string.format("Error compiling module '%s': %s", module_name, compile_err), 2) end

    local success, result = pcall(func)
    if not success then error(string.format("Error executing module '%s': %s", module_name, result), 2) end

    return result
end

-- require = function(module_name)
--     return LGF:LuaLoader(module_name)
-- end


local Framework = {
    { ResourceName = "LEGACYCORE",  Object = "GetCoreData" },
    { ResourceName = "es_extended", Object = "getSharedObject" },
    { ResourceName = "qb-core",     Object = "GetCoreObject" },
}


function LGF:GetFramework()
    for I = 1, #Framework do
        local DATA = Framework[I]
        if GetResourceState(DATA.ResourceName):find("started") then
            local success, frame = pcall(function()
                return exports[DATA.ResourceName][DATA.Object]()
            end)
            if success then
                return frame, DATA.ResourceName
            else
                LGF:logError("Failed to Get Object from %s, Result %s", DATA.ResourceName, frame)
            end
        end
    end
end

if LGF:GetContext() == "client" then
    function LGF.Player:Ped()
        return PlayerPedId()
    end

    function LGF.Player:Index()
        return GetPlayerServerId(NetworkGetPlayerIndexFromPed(self:Ped()))
    end

    function LGF.Player:PlayerId()
        return PlayerId()
    end

    function LGF.Player:Coords()
        return GetEntityCoords(self:Ped())
    end
end


exports('UtilityData', function()
    return _G.LGF
end)
