local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")

local M = {}

local function creator(args)
    local reg = {
        widget = wibox.widget.textbox()
    }
    reg.vicwidget = vicious.register(reg.widget, vicious.widgets.bat, function(w, args)
        M.args = args
        return string.format("%s %i%%", args[1], args[2])
    end, 61, "BAT1")
    return reg
end

function M.update(reg)
    vicious.force({ reg.widget })
end

function M.attach(widget, reg)
    utils.registerPopupNotify(widget, "Battery", function(w)
        return string.format("Time remaining:\t%s\nWear level:\t\t%i%%", M.args[3], M.args[4])
    end)
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
