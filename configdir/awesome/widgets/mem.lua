local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local wibox = require("wibox")
local BaseWidget = require("widgets.base").BaseWidget

local MemWidget = BaseWidget.derive()

-- timeout: refresh interval
-- icon: icon path
function MemWidget:create(args)
    args = args or {}
    args.settings = function()
        self.data = mem_now
        widget:set_markup(mem_now.perc .. "%")
    end

    self.lainwidget = lain.widget.mem(args)
    -- local box = self:init(self.lainwidget.widget, args.icon or icons.mem, 0)
    local box = self:init(self.lainwidget.widget)
    -- box:insert(1, wibox.widget.textbox("  \u{f2db}  "))
    box:insert(1, wibox.widget.textbox("  \u{f538}  " ))
    self:attach(box)
end

function MemWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
                utils.toggle_run_term("htop --sort-key PERCENT_MEM")
            end)
    ))

    utils.registerPopupNotify(box, "Memory", function(w)
        return string.format(table.concat({
            "Used:\t%.2f GB",
            "Free:   \t%.2f GB",
            "Total:\t%.2f GB\n",
            "<b>System</b>",
            "Buffers:       \t%i MB",
            "Cached:     \t%i MB",
            "SReclaimable:\t%i MB\n",
            "<b>Swap</b>",
            "Used:\t%.2f GB",
            "Free:   \t%.2f GB",
            "Total:\t%.2f GB",
        }, "\n"),
        self.data.used / 1000,
        self.data.free / 1000,
        self.data.total / 1000,
        self.data.buf,
        self.data.cache,
        self.data.srec,
        self.data.swapused / 1000,
        self.data.swapf / 1000,
        self.data.swap / 1000)
    end)
end

return MemWidget
