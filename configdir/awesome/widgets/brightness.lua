local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local BrightWidget = BaseWidget.derive()

function BrightWidget:update()
    self.widget:set_text(tostring(self:getBrightness()) .. "%")
end

function BrightWidget:create(args)
    args = args or {}

    self.widget = wibox.widget.textbox()
    self.device = "/sys/class/backlight/" .. (args.device or "intel_backlight") .. "/brightness"
    self.addcmd = args.addcmd or "light -A"
    self.subcmd = args.subcmd or "light -U"

    local box = self:init(self.widget, args.icon or icons.brightness)
    self:attach(box)

    self.timer = gears.timer({ timeout = args.timeout or 11 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()
    self:update()
end

function BrightWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 4, function()
            self:incBrightness(5)
        end),
        awful.button({}, 5, function()
            self:incBrightness(-5)
        end)
    ))
end

function BrightWidget:getBrightness()
    -- xbacklight causes freezes
    return math.ceil((utils.read_number(self.device, -10)) / 10)
end

function BrightWidget:incBrightness(val)
    local cmd = val < 0 and self.subcmd or self.addcmd
    utils.async(cmd .. " " .. tostring(math.abs(val)), function(out) self:update() end)
end

return BrightWidget
