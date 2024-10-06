---@[[TYPES]]
---@class NotificationData
---@field id string Unique ID for the notification
---@field title string Title of the notification
---@field message string Message of the notification
---@field icon string Icon type (e.g., "success", "error", "progress", "line")
---@field duration number Duration of the notification in milliseconds
---@field position string Position of the notification (e.g., "top-left", "top-right", "bottom-left", "bottom-right")


---@param data NotificationData
local function showNotification(data)
    local message = data.message
    local title = data.title
    local icon = data.icon
    local duration = data.duration
    local position = data.position
    local id = data.id

    SendNUIMessage({
        action = "SendNotification",
        id = id,
        title = title,
        message = message,
        icon = icon,
        duration = duration,
        position = position
    })
end


RegisterNetEvent('LGF_Utility:SendNotification', function(data)
    showNotification({
        id = data.id,
        title = data.title,
        message = data.message,
        icon = data.icon,
        duration = data.duration,
        position = data.position
    })
end)


exports('SendNotification', showNotification)

-- Example usage:
--[[
    TriggerEvent('LGF_Utility:SendNotification', {
        id = "progress1",
        title = "Processing",
        message = "Your request is being processed.",
        icon = "progress",
        duration = 5000,
        position = 'top-right'
    })

    exports['LGF_Utility']:SendNotification({
        id = "example1",
        title = "Hello",
        message = 'This is a notification example.',
        icon = 'success',
        duration = 5000,
        position = 'top-left'
    })
]]


