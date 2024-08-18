## LGF_UI API

<table>
  <tr>
    <td><img src="https://cdn.discordapp.com/attachments/1217899422604595300/1274779710689382631/Aggiungi_un_titolo_2.png?ex=66c37e9f&is=66c22d1f&hm=f24b562bff9138f711459241343bc3da6a9c230400abf3f10edd37e7f01c2c5a&" alt="CONTEXT / TEXTUI / NOTIFICATION" width="150"/></td>
  </tr>
</table>



### Context Menu

```lua

exports['LGF_UI']:ShowContextMenu(menuID, show)
exports['LGF_UI']:IsUiOpen()
exports['LGF_UI']:RegisterContextMenu(menuID, menuTitle, data)
exports['LGF_UI']:CloseContext(menuID)
exports['LGF_UI']:ForceCloseContext()
exports['LGF_UI']:CanOpenContext()

--[[STATE BAG CONTEXT]] -- Returns true or false
LocalPlayer.state.ContextOpen
```
### Noification System

```lua
-- Send a notification with exports
exports['LGF_UI']:SendNotification(data)

-- Trigger a notification event on the client side
TriggerClientEvent('LGF_UI:SendNotification', target, data)

-- Trigger a notification event on the server side
TriggerEvent('LGF_UI:SendNotification', data)
```

### TextUI

```lua
-- Open the text UI with specific data
exports['LGF_UI']:OpenTextUI(data)

-- Get the state of the text UI (whether it is currently open or not)
exports['LGF_UI']:GetStateTextUI()

-- Hide the text UI
exports['LGF_UI']:HideTextUI()
```
