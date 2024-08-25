NUI = {}
_G.isUIOpen = false
LocalPlayer.state.contextOpened = false


local function CanOpenContext()
  return not Config.isPlayerDead() and
      not LocalPlayer.state.invOpen and
      not IsPauseMenuActive() and
      not _G.isUIOpen
end

function NUI:showNui(action, menuID, show)
  SetNuiFocus(show, show)
  SendNUIMessage({ action = action, data = { menuID = menuID, visible = show } })
  if action == 'CreateMenuContext' then
    _G.isUIOpen = true
    LocalPlayer.state.contextOpened = true
  end
end

RegisterNuiCallback('UI:CloseContext', function(data, cb)
  print(json.encode(data))
  SetNuiFocus(false, false)
  SendNUIMessage({ action = "CreateMenuContext", data = { menuID = data.menuID, visible = false } })
  _G.isUIOpen = false
  LocalPlayer.state.contextOpened = false
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
