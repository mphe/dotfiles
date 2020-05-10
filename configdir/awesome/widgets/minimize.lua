local awful = require("awful")
local wibox = require("wibox")
local utils = require("utils")
local BaseWidget = require("widgets.base").BaseWidget

local MinimizeWidget = BaseWidget.derive()

function MinimizeWidget:create(args)
    local args = args or {}

    -- self.widget = wibox.widget.textbox()
    -- self.widget:set_text(" ")

    self.minimized = false
    self.clients = {}
    self.widget = wibox.container.constraint(wibox.widget.textbox(), "exact", 2, nil)
    local box = self:init(self.widget)
    self:attach(self.widget)

    -- self.timer = timer({ timeout = 1 })
    -- self.timer:connect_signal("timeout", function() self:timeout() end)

    -- self.timer:start()
end

function MinimizeWidget:timeout()
end

function MinimizeWidget:toggle()
    if self.minimized then
        for _, c in ipairs(self.clients) do
            c.minimized = false
        end
        self.clients = {}
    else
        for _, c in ipairs(mouse.screen.clients) do
            if c.type ~= "desktop" and not c.minimized then
                c.minimized = true
                table.insert(self.clients, c)
            end
        end
    end

    self.minimized = not self.minimized;
end

function MinimizeWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            self:toggle()
        end)
    ))
end

return MinimizeWidget
