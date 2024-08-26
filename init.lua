local loaded_modules = {}


if not _G.LGF then _G.LGF = {} end

function LGF:GetPath()
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

function LGF:LuaLoader(module_name)
    local resource_name = GetInvokingResource() or "LGF_Utility"

    if loaded_modules[module_name] then
        return loaded_modules[module_name]
    end

    local file_name = module_name .. ".lua"
    local file_content = LoadResourceFile(resource_name, file_name)

    if not file_content then
        error(string.format("Error loading file '%s' from resource '%s': File does not exist or cannot be read.",
            file_name, resource_name))
    end

    local func, compile_err = load(file_content, "@" .. file_name)
    if not func then
        error(string.format("Error compiling module '%s': %s", module_name, compile_err))
    end

    local success, result = pcall(func)

    if not success then
        error(string.format("Error executing module '%s': %s", module_name, result))
    end

    loaded_modules[module_name] = result

    return result
end

exports('UtilityData', function()
    return _G.LGF
end)
