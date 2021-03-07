local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local wibox = require("wibox")
local icons = require("icons")
local beautiful = require("beautiful")
local BaseWidget = require("widgets.base").BaseWidget

local CPUWidget = BaseWidget.derive()

function CPUWidget:create(args)
    args = args or {}
    args.settings = function()
        self.data = cpu_now
        widget:set_markup(cpu_now.usage .. "%")
    end

    self.lainwidget = lain.widget.cpu(args)
    local widget = wibox.container.constraint(self.lainwidget.widget, "exact", beautiful.dpi(28), nil)
    widget.widget.align = "right"

    -- local box = self:init(widget, args.icon or icons.cpu, 0)
    local box = self:init(widget, args.icon or icons.cpu)
    -- local box = self:init(widget)
    -- box:insert(1, wibox.widget.textbox("  \u{f2db}  "))
    self:attach(box)
end

function CPUWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
                utils.toggle_run_term("htop --sort-key PERCENT_CPU")
            end)
    ))

    utils.registerPopupNotify(box, "CPU", function(w)
            local cpus = {}
            for i=1,#self.data do
                cpus[i] = string.format("Core %i:\t%i%%", i, self.data[i].usage)
            end
            return table.concat(cpus, "\n")
        end)
end

return CPUWidget
