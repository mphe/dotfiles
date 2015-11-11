local awful = require("awful")
local wibox = require("wibox")

local M = {}

local function creator(args)
    local reg = {
        visible = true,
        stupid_bug = drawin({}),
        systray = wibox.widget.systray(),
        widget = wibox.layout.constraint(),
    }
    reg.widget:set_widget(reg.systray)
    reg.widget:set_strategy("min")
    reg.widget:set_width(4)
    return reg
end

function M.toggle(reg, visible)
    visible = visible or not reg.visible
    if visible == reg.visible then return end

    if visible then
        reg.widget:set_strategy("min")
        reg.widget:set_widget(reg.systray)
    else
        awesome.systray(reg.stupid_bug, 0, 0, 10, true, "#000000")
        reg.widget:set_widget(nil)
        reg.widget:set_strategy("exact")
    end
    reg.visible = not reg.visible
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
