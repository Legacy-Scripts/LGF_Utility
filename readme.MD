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
## Notification System

```lua
-- CLIENT SIDE
exports['LGF_UI']:SendNotification(data)

-- SERVER SIDE
TriggerClientEvent('LGF_UI:SendNotification', target, data)

-- CLIENT SIDE
TriggerEvent('LGF_UI:SendNotification', data)
```

## TextUI

```lua


---@class TextUIData
---@field title string The title of the Text UI (optional)
---@field message string The message to display
---@field colorProgress string Progress color (optional)
---@field keyBind string Keybind to display (optional, only if useKeybind is true also show the loader)
---@field position string Position of the UI (e.g., "center", "center-left", "center-right")
---@field useKeybind boolean Show the keybind (optional)
---@field useProgress boolean Show the loader (optional)

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


