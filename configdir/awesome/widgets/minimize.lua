local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local BaseWidget = require("widgets.base").BaseWidget

local MinimizeWidget = BaseWidget.derive()

function MinimizeWidget:create(args)
    args = args or {}

    self.minimized = false
    self.clients = {}
    self.hover_timeout = args.hover_timeout or 1.5
    self.widget = wibox.container.constraint(nil, "exact", 2, nil)
    local box = self:init(self.widget)

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
            self:toggle()
        end)
    ))

    -- Mouse Hover events are not triggered during drag and drop.
    -- box:connect_signal('mouse::enter', function()
    --     self.timer = gears.timer.start_new(self.hover_timeout, function()
    --         self:toggle()
    --     end)
    -- end)

    -- box:connect_signal('mouse::leave', function()
    --     self:_stop_timer()
    -- end)

    -- self.timer:start()
end

function MinimizeWidget:_stop_timer()
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
end

function MinimizeWidget:toggle()
    if self.minimized then
        for _, c in ipairs(self.clients) do
            if c.valid then
                c.minimized = false
            end
        end
        self.clients = {}
        utils.notify("Restored")
    else
        for _, c in ipairs(mouse.screen.clients) do
            if c.type ~= "desktop" and not c.minimized then
                c.minimized = true
                table.insert(self.clients, c)
            end
        end
        utils.notify("Minimized")
    end

    self.minimized = not self.minimized;
    self:_stop_timer()
end

return MinimizeWidget
