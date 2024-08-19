  ![](https://img.shields.io/github/downloads/ENT510/LGF_UI/total?logo=github)
  ![](https://img.shields.io/github/v/release/ENT510/LGF_UI?logo=github)


## LGF_UI API

## Context Menu

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
## Noification System

```lua
-- Send a notification with exports
exports['LGF_UI']:SendNotification(data)

-- Trigger a notification event on the client side
TriggerClientEvent('LGF_UI:SendNotification', target, data)

-- Trigger a notification event on the server side
TriggerEvent('LGF_UI:SendNotification', data)
```

## TextUI

```lua
-- Open the text UI with specific data
exports['LGF_UI']:OpenTextUI(data)

-- Get the state of the text UI (whether it is currently open or not)
exports['LGF_UI']:GetStateTextUI()

-- Hide the text UI
exports['LGF_UI']:HideTextUI()
```

<table>
  <tr>
    <td>
      <img src="https://cdn.discordapp.com/attachments/1200838616679727195/1275205843771457556/image.png?ex=66c50b7d&is=66c3b9fd&hm=af37267a780110939b41bcb5084ce79905685164b3a9099a508ae90bbd303312&" alt="Textui Whit Bind" width="500" height="500"/>
    </td>
    <td>
      <img src="https://cdn.discordapp.com/attachments/1200838616679727195/1275206210173272307/image.png?ex=66c50bd4&is=66c3ba54&hm=6134e0c7a3026b79893a510794d3f02b14e8d078331b1aef63970ecef5a74c0c&" alt="Textui Whit Bind" width="500" height="500"/>
    </td>
  </tr>
</table>






## Dialog 

```lua
-- Register a Dialog with params
exports['LGF_UI']:RegisterDialog(data)

-- Close Specific Dialog
exports['LGF_UI']:CloseDialog(dialogID)
```


## ProgressBar 

```lua
-- Register a Progressbar whit params
exports['LGF_UI']:CreateProgressBar()

-- Disable Current progress
exports['LGF_UI']:DisableProgressBar()

-- Get State of Curren ProgressBar (return true or false)
exports['LGF_UI']:GetStateProgress()

```


