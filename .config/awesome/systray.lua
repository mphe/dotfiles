-- Provides a toggleable systray widget.
-- Code is based on this old wiki entry:
-- http://web.archive.org/web/20160316064839/http://awesome.naquadah.org/wiki/Systray_Hide/Show

local awful = require("awful")
local wibox = require("wibox")

local M = {}

local function creator(reverse)
    local tray = wibox.widget.systray(reverse)
    return {
        visible = true,
        stupid_bug = drawin({}),
        systray = tray,
        widget = wibox.container.constraint(tray, "min"),
        toggle = M.toggle
    }
end

function M.toggle(reg, visible)
    if visible == reg.visible then
        return
    end
    reg.visible = not reg.visible

    if reg.visible then
        reg.widget:set_strategy("min")
        reg.widget:set_widget(reg.systray)
    else
        awesome.systray(reg.stupid_bug, 0, 0, 10, true, "#000000") -- black magic
        reg.widget:set_strategy("exact")
        reg.widget:set_widget(nil)
    end
end

return setmetatable(M, { __call = function(_, ...) return creator(...) end })
