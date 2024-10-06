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
  print(show, show)
  SetNuiFocus(true, true)
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


exports('GetContextState', function() return NUI:isUIOpen() end)
exports('CanOpenContext', CanOpenContext)

--[[
    exports['LGF_Utility']:ShowContextMenu(menuID, show)
    exports['LGF_Utility']:IsUiOpen()
    exports['LGF_Utility']:RegisterContextMenu(menuID, menuTitle, data)
    exports['LGF_Utility']:CloseContext(menuID)
    exports['LGF_Utility']:ForceCloseContext()
    exports['LGF_Utility']:CanOpenContext()
    LocalPlayer.state.ContextOpen
]]
