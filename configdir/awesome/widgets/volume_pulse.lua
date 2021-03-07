local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local VolWidget = BaseWidget.derive()

function VolWidget:create(args)
    args = args or {}

    self.default_step = args.default_step or 3  -- Default volume step in percent

    args.settings = function()
        self.volume_now = volume_now
        local vol = (self.volume_now.left + self.volume_now.right) / 2

        widget:set_markup(math.floor(vol) .. "%")

        if self.volume_now.muted == "no" then
            self:set_icon(icons.get_3level("volume", vol))
        else
            self:set_icon(icons.muted)
        end
    end

    self.lainwidget = lain.widget.pulse(args)
    local box = self:init(self.lainwidget.widget, icons.volume_high)

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run("pavucontrol") end),
        awful.button({}, 3, function() self:toggleMute() end),
        awful.button({}, 4, function() self:incVolume() end),
        awful.button({}, 5, function() self:decVolume() end)
    ))
end

function VolWidget:update()
    self.lainwidget.update()
end

function VolWidget:incVolume(val)
    val = val or self.default_step
    self:changeVolume(string.format("+%s", val))
end

function VolWidget:decVolume(val)
    val = val or self.default_step
    self:changeVolume(string.format("-%s", val))
end

-- val should be a string "+X" or "-X"
function VolWidget:changeVolume(val)
    -- utils.async("amixer -c 0 set Master " .. val, function(stdout) self:update() end)
    print(self.volume_now.device)
    utils.async(string.format("pactl set-sink-volume %s %s%%", self.volume_now.device, val),
        function(_) self:update() end)
end

function VolWidget:toggleMute()
    -- utils.async("amixer set Master toggle", function(stdout) self:update() end)
    os.execute(string.format("pactl set-sink-mute %s toggle", self.volume_now.device),
        function(_) self:update() end)
end

return VolWidget
