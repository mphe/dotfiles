local icons = require("icons")
local utils = require("utils")
local wibox = require("wibox")

local M = {}

M.widgets = {
    brightness = require("widgets.brightness"),
    volume = require("widgets.volume"),
    mpd = require("widgets.mpd"),
    cpu = require("widgets.cpu"),
    mem = require("widgets.mem"),
    bat = require("widgets.bat"),
    tray = require("widgets.tray")
}

-- Returns a wibox.layout.fixed.horizontal containing the widget and icon
function M.bind_to_icon(widget, icon)
    local box = wibox.layout.fixed.horizontal()
    if icon then
        box:add(icons.loadIcon(icon))
    end
    box:add(widget)

    return box
end

function M.create(witype, icon, args)
    local reg = witype(args)
    reg.witype = witype
    reg.container = M.bind_to_icon(reg.widget, icon)

    if witype.attach then
        witype.attach(reg.container, reg)
    end

    return reg
end

function M.update(reg)
    if reg.witype.update then
        reg.witype.update(reg)
    end
end

return M
