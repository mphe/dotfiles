local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")

local M = {}

local function creator(args)
    local reg = {
        widget = wibox.widget.textbox()
    }
    vicious.register(reg.widget, vicious.widgets.volume, "$2 $1%", 5, "Master")
    return reg
end

function M.update(reg)
    vicious.force({ reg.widget })
end

function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run("pavucontrol") end),

        awful.button({}, 3, function()
            M.toggleMute()
            M.update(reg)
        end),

        awful.button({}, 4, function()
            M.changeVolume("1dB+")
            M.update(reg)
        end),

        awful.button({}, 5, function()
            M.changeVolume("1dB-")
            M.update(reg)
        end)
    ))
end

function M.changeVolume(val)
    awful.util.spawn("amixer -c 0 set Master " .. val)
end

function M.toggleMute()
    awful.util.pread("amixer set Master toggle") -- pread -> force wait
end

function M.isMuted()
    return awful.util.pread("amixer get Master | grep off") ~= ""
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
