```lua
--[[REGISTER CONTEXT MENU EXPORTS]]
    exports['LGF_UI']:ShowContextMenu(menuID, show)
    exports['LGF_UI']:IsUiOpen()
    exports['LGF_UI']:RegisterContextMenu(menuID, menuTitle, data)
    exports['LGF_UI']:CloseContext(menuID)
    exports['LGF_UI']:ForceCloseContext()
    exports['LGF_UI']:CanOpenContext()

    --[[STATE BAG]] == "return true or false"
    LocalPlayer.state.ContextOpen

    --[[NOTIFICATION ]]
```

--[[
    TriggerEvent('LGF_UI:SendNotification', {
        id = "progress1",
        title = "Processing",
        message = "Your request is being processed.",
        icon = "progress",
        duration = 5000,
        position = 'top-right'
    })

    exports['LGF_UI']:SendNotification({
        id = "example1",
        title = "Hello",
        message = 'This is a notification example.',
        icon = 'success',
        duration = 5000,
        position = 'top-left'
    })
]]
