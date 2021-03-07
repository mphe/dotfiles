local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local BrightWidget = BaseWidget.derive()

function BrightWidget:update()
    utils.async(self.getcmd, function(out)
        self._brightness_perc = math.ceil(out)
        self.widget:set_text(tostring(self._brightness_perc) .. "%")
        self:set_icon(icons.get_3level("brightness", self._brightness_perc))
    end)
end

function BrightWidget:create(args)
    args = args or {}

    self.widget = wibox.widget.textbox()
    -- self.device = "/sys/class/backlight/" .. (args.device or "intel_backlight")
    self.addcmd = args.addcmd or "light -A"
    self.subcmd = args.subcmd or "light -U"
    self.getcmd = args.subcmd or "light"

    self._brightness_perc = 0

    local box = self:init(self.widget, icons.brightness_high)

    box:buttons(awful.util.table.join(
        awful.button({}, 4, function()
            self:incBrightness(5)
        end),
        awful.button({}, 5, function()
            self:incBrightness(-5)
        end)
    ))

    self.timer = gears.timer({ timeout = args.timeout or 11 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()
    self:update()
end

function BrightWidget:getBrightness()
    return self._brightness_perc
end

function BrightWidget:incBrightness(val)
    local cmd = val < 0 and self.subcmd or self.addcmd
    utils.async(string.format("%s %s", cmd, tostring(math.abs(val))), function(out) self:update() end)
end

return BrightWidget
