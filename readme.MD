# LGF_UI API

![GitHub Downloads](https://img.shields.io/github/downloads/ENT510/LGF_UI/total?logo=github)
![GitHub Release](https://img.shields.io/github/v/release/ENT510/LGF_UI?logo=github)

**LGF_UI** is a comprehensive UI framework designed to provide a seamless user interface experience for your application. This API offers a variety of tools, including context menus, notification systems, text UIs, dialogs, progress bars, and input forms, all of which can be easily integrated into your project.

## Installation

If you need to edit the UI, you'll need Node.js installed on your machine. Here’s how you can set up your environment:

1. **Install Dependencies**
   Navigate "web" project directory and run the following command to install the necessary modules:
```bash
npm i
```

2. **Build the Project**
After editing or making changes to the UI, you can rebuild the project using:

```bash
npm run build
```

For detailed documentation, visit the [LGF_UI Documentation on GitBook](https://legacy-script.gitbook.io/legacy-core/free-release/lgf-ui).


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

![Context Menu](https://cdn.discordapp.com/attachments/1217899672899944509/1277354650659717181/image.png?ex=66ccdcb8&is=66cb8b38&hm=2870c95f721b968ed35198c9c21a20ad69ef07a007cf47cf6a5462d913ce47d1)

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

![Text-UI](https://cdn.discordapp.com/attachments/1217899672899944509/1277355242828337292/keybind.png?ex=66ccdd46&is=66cb8bc6&hm=dac2f940b90f8dce0c3ee02abd4eb13fc468441b2ef49778a7c04c0ddd346796&)


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

![Input](https://cdn.discordapp.com/attachments/1217899672899944509/1277355891108347974/image.png?ex=66ccdde0&is=66cb8c60&hm=1ca49b8f0535bcbf50a460ead95c57c550f50bff3d8f2febf393b7a87b7a4d78&)

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

![Input](https://cdn.discordapp.com/attachments/1217899672899944509/1277355606260580383/image.png?ex=66ccdd9c&is=66cb8c1c&hm=c6710a359100fac69e2040d304f8c6e33941b005a026d682d2ae3f3606185d1b&)


