# LGF_UI API

![GitHub Downloads](https://img.shields.io/github/downloads/ENT510/LGF_UI/total?logo=github)
![GitHub Release](https://img.shields.io/github/v/release/ENT510/LGF_UI?logo=github)

**LGF_UI** is a comprehensive UI framework designed to provide a seamless user interface experience for your application. This API offers a variety of tools, including context menus, notification systems, text UIs, dialogs, progress bars, and input forms, all of which can be easily integrated into your project.

## Installation

If you need to edit the UI, you'll need Node.js installed on your machine. Here’s how you can set up your environment:

1. **Install Dependencies**  
   Navigate to your project directory and run the following command to install the necessary modules:
```bash
   npm i
```

2. **Build the Project**

After editing or making changes to the UI, you can rebuild the project using:

```bash
npm run build
```
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

-- Get State Dialog , Return true or false
exports['LGF_UI']:GetDialogState()
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

## Input 

```lua
-- Register a input whit multi params
exports['LGF_UI']:RegisterInput(id, title, data)

-- Close a specific input
exports['LGF_UI']:CloseInput(id)

-- Show a specific Input (Must be registered)
exports['LGF_UI']:ShowInput(id)

-- Get State Input , Return true or false
exports['LGF_UI']:GetInputState()

-- Close all Input Opened
exports['LGF_UI']:ForceCloseInput()

```


