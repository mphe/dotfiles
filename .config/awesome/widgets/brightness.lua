local awful = require("awful")
local wibox = require("wibox")

local M = {}

function M.getBrightness()
    return tonumber(awful.util.pread("xbacklight -get"))
end

function M.changeBrightness(x)
    awful.util.pread("xbacklight -inc " .. tostring(x))
end

function M.update(reg)
    -- reg.callback(reg.widget, M.getBrightness())
    reg.widget:set_text(tostring(math.ceil(M.getBrightness())) .. "%")
end

local function creator(args)
    local args = args or {}
    local reg = {
        widget = wibox.widget.textbox(),
        -- callback = callback,
        timer = timer({ timeout = args.interval or 5 })
    }

    reg.timer:connect_signal("timeout", function() M.update(reg) end)
    reg.timer:start()
    M.update(reg)
    return reg
end

function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 4, function()
            M.changeBrightness(5)
            M.update(reg)
        end),
        awful.button({}, 5, function()
            M.changeBrightness(-5)
            M.update(reg)
        end)
    ))
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
