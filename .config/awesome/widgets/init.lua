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

function M.create(witype, icon, args)
    local reg = witype(args)
    reg.witype = witype

    -- Create container to store the icon and widget
    local box = wibox.layout.fixed.horizontal()
    if icon then
        box:add(icons.loadIcon(icon))
    end
    box:add(reg.widget)
    if witype.attach then
        witype.attach(box, reg)
    end

    -- Add the container to the registration object
    reg.container = box

    return reg
end

function M.update(reg)
    if reg.witype.update then
        reg.witype.update(reg)
    end
end

return M
