local MenuMetaTable = {}
MenuMetaTable.__index = MenuMetaTable
local CONTEXT_MENUS = {}

function MenuMetaTable.new(menuID, menuTitle, items)
    local self = setmetatable({}, MenuMetaTable)
    self.id = menuID
    self.title = menuTitle
    self.items = items
    return self
end

function MenuMetaTable:getItem(index)
    return self.items[index]
end

function MenuMetaTable:selectItem(index)
    local item = self:getItem(index)
    if item and item.onSelect then
        item.onSelect()
        return true
    end
    return false
end

local function registerMenu(menuID, menuTitle, items)
    if not menuID or not menuTitle or not items then
        print(('Error: Missing data in registerMenu. MenuID: %s, MenuTitle: %s, Items: %s'):format(
            tostring(menuID or "nil"),
            tostring(menuTitle or "nil"),
            tostring(items or "nil")
        ))
        return
    end

    CONTEXT_MENUS[menuID] = MenuMetaTable.new(menuID, menuTitle, items)
    _G.isUIOpen = true
end

RegisterNuiCallback('LGF_UI.GetContextData', function(data, cb)
    local menuID = data.menuID
    local menuData = CONTEXT_MENUS[menuID]

    if menuData then
        cb({
            id = menuData.id,
            title = menuData.title,
            items = menuData.items
        })
    else
        cb(nil)
    end
end)

RegisterNuiCallback('menu:ItemSelected', function(data, cb)
    local menu = CONTEXT_MENUS[data.menuID]
    if menu then
        local itemIndex = tonumber(data.itemIndex) + 1
        local success = menu:selectItem(itemIndex)

        cb(success)
    else
        cb(false)
    end
end)


exports('RegisterContextMenu', registerMenu)
