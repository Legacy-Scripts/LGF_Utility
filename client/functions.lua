NUI = {}
_G.isUIOpen = false

local function CanOpenContext()
  return not Config.isPlayerDead() and
      not LocalPlayer.state.invOpen and
      not IsPauseMenuActive() and
      not _G.isUIOpen
end


function NUI:showNui(action, menuID, shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendNUIMessage({ action = action, data = { menuID = menuID, visible = shouldShow } })
  if action == 'CreateMenuContext' then
    _G.isUIOpen = shouldShow
    LocalPlayer.state:set('ContextOpen', shouldShow, true)
  end
end

RegisterNuiCallback('ui:Close', function(data, cb)
  NUI:showNui('CreateMenuContext', data.menuID, false)
  if data.name == 'CreateMenuContext' then
    _G.isUIOpen = false
  end
  cb(true)
end)

function NUI:isUIOpen()
  return _G.isUIOpen
end

exports('ShowContextMenu', function(menuID, shouldShow) return NUI:showNui('CreateMenuContext', menuID, shouldShow) end)

exports('ForceCloseContext', function()
  NUI:showNui('CreateMenuContext', nil, false)
  _G.isUIOpen = false
end)

exports('CloseContext', function(menuID)
  NUI:showNui('CreateMenuContext', menuID, false)
  _G.isUIOpen = false
end)

exports('IsUiOpen', function() return NUI:isUIOpen() end)
exports('CanOpenContext', CanOpenContext)

--[[
    exports['LGF_UI']:ShowContextMenu(menuID, show)
    exports['LGF_UI']:IsUiOpen()
    exports['LGF_UI']:RegisterContextMenu(menuID, menuTitle, data)
    exports['LGF_UI']:CloseContext(menuID)
    exports['LGF_UI']:ForceCloseContext()
    exports['LGF_UI']:CanOpenContext()
    LocalPlayer.state.ContextOpen
]]
