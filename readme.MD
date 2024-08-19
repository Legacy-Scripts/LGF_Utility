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

![Textui Whit Bind](https://cdn.discordapp.com/attachments/1200838616679727195/1275204568422289448/image.png?ex=66c50a4d&is=66c3b8cd&hm=389f9eb8f0e8d6e182b7e33170cb736608d891f5df2ee18c02bc4620fd2872f4&)

```lua
-- Open the text UI with specific data
exports['LGF_UI']:OpenTextUI(data)

-- Get the state of the text UI (whether it is currently open or not)
exports['LGF_UI']:GetStateTextUI()

-- Hide the text UI
exports['LGF_UI']:HideTextUI()
```


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


