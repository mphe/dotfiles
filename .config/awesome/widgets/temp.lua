local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")

local M = {}

local function creator(args)
    args = args or {}
    args.critical = args.critical or 80
    args.critcolor = args.critcolor or "#FF0000"
    args.interval = args.interval or 59

    local reg = {
        widget = wibox.widget.textbox()
    }

    reg.vicwidget = vicious.register(reg.widget, vicious.widgets.thermal, function(w, args_)
        t = args_[1]
        if t >= args.critical then
            return string.format('<span color="%s">%s°C</span>', args.critcolor, t)
        end
        return t .. "°C"
    end , args.interval, "thermal_zone0")

    vicious.cache(vicious.widgets.thermal)

    return reg
end

function M.update(reg)
    vicious.force({ reg.vicwidget })
end

function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run("psensor") end)
    ))
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
