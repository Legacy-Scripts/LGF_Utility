## LGF_UI API

![CONTEXT / TEXTUI / NOTIFICATION](https://cdn.discordapp.com/attachments/1217899422604595300/1274777105577541775/Aggiungi_un_titolo_1.png?ex=66c37c32&is=66c22ab2&hm=7ed77a5d874a79d0dd755ff2e03e9bacdad55a09db8b0005579e320e19ce9185&)


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
