local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
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

    local box = self:init(lain.widgets.mem(args), args.icon or icons.mem)
    self:attach(box)
end

function MemWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
                utils.toggle_run_term("htop --sort-key PERCENT_MEM")
            end)
    ))

    utils.registerPopupNotify(box, "Memory", function(w)
            return string.format("Memory usage:\t%i MB\nSwap usage:\t%i MB",
                self.data.used, self.data.swapused)
        end)
end

return MemWidget
