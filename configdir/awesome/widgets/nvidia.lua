local awful = require("awful")
local utils = require("utils")
local gears = require("gears")
local wibox = require("wibox")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local Nvidia = BaseWidget.derive()

-- timeout: refresh interval
function Nvidia:create(args)
    args = args or {}
    self.nvswitch_path = args.nvswitch_path or "nvswitch.sh"
    self.autohide = args.autohide or true

    self._is_on = false
    self.widget = wibox.widget.textbox()
    local box = self:init(self.widget, icons.nvidia)

    -- Add missing spacing
    box:insert(1, wibox.widget.textbox("  "))

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() self:toggle() end)
    ))

    self.timer = gears.timer({ timeout = args.timeout or 122 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()

    self:update()
end

function Nvidia:toggle()
    -- utils.notify("Not implemented due to inconsistency. Use the terminal.")
    awful.spawn.easy_async(string.format("pkexec %s toggle", self.nvswitch_path), function(stdout, stderr, reason, code)  -- luacheck: ignore
        if string.len(stdout) > 0 then utils.notify(utils.StripANSI(stdout), "Output", 5) end
        if string.len(stderr) > 0 then utils.notify(utils.StripANSI(stderr), "Error", 5) end
        self:update()
    end)
end

function Nvidia:is_on()
    return self._is_on
end

function Nvidia:update(after_cb)
    awful.spawn.easy_async(self.nvswitch_path .. " is_on", function(stdout, stderr, reason, code)  -- luacheck: ignore
        self._is_on = code == 0
        self:get_container():set_visible(self._is_on or not self.autohide)

        if self._is_on then
            self:set_icon(icons.nvidia_green)
        else
            self:set_icon(icons.nvidia)
        end

        if after_cb then
            after_cb()
        end
    end)
end

return Nvidia
