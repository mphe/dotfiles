local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local VolWidget = BaseWidget.derive()

-- timeout: refresh interval
-- icon: icon path
function VolWidget:create(args)
    args = args or {}
    args.channel = args.channel or "Master"
    args.togglechannel = args.togglechannel or "Master"
    args.settings = function()
        widget:set_markup(volume_now.level .. "%")
        self:updateIcon(volume_now.status)
    end

    self.status = "on"
    self.lainwidget = lain.widgets.alsa(args)
    local box = self:init(self.lainwidget.widget, args.icon or icons.volume)

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run("pavucontrol") end),
        awful.button({}, 3, function() self:toggleMute() end),
        awful.button({}, 4, function() self:changeVolume("1dB+") end),
        awful.button({}, 5, function() self:changeVolume("1dB-") end)
    ))
end

function VolWidget:update()
    self.lainwidget.update()
end

function VolWidget:updateIcon(status)
    if self.status == status then
        return
    elseif status == "on" then
        self:set_icon(icons.volume)
    else
        self:set_icon(icons.muted)
    end
    self.status = status
end

function VolWidget:changeVolume(val)
    utils.async("amixer -c 0 set Master " .. val, function(stdout) self:update() end)
end

function VolWidget:toggleMute(reg)
    utils.async("amixer set Master toggle", function(stdout) self:update() end)
end

return VolWidget
