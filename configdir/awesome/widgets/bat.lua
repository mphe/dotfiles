local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local BatWidget = BaseWidget.derive()

function BatWidget:create(args)
    args = args or {}
    args.settings = function()
        -- luacheck: globals bat_now widget
        if bat_now.ac_status == 1 then
            widget:set_markup(bat_now.perc .. "%")
        else
            local hours, minutes = string.match(bat_now.time, "(%d+):(%d+)")
            widget:set_markup(string.format("%s%% (%d:%02dh)", bat_now.perc, hours, minutes))
        end

        self.data = bat_now
        self:updateIcon()

        -- Calculate remaining capacity
        -- TODO: Consider adding this in lain and create a pull request
        local batpath = "/sys/class/power_supply/" .. (args.battery or "BAT0")
        local charge_full = utils.read_number(batpath .. "/charge_full", 0)
        local charge_full_design = utils.read_number(batpath .. "/charge_full_design", nil)

        if not charge_full_design or charge_full_design == 0 then
            self.data.capacity_perc = "N/A"
        else
            self.data.capacity_perc = math.floor((charge_full / charge_full_design) * 100)
        end
    end

    self.lainwidget = lain.widget.bat(args)
    local box = self:init(self.lainwidget.widget, args.icon or icons.ac)
    self:updateIcon()

    utils.registerPopupNotify(box, "Battery", function(w)
            return string.format("Time remaining:\t%s\nCapacity:\t%s%%",
                self.data.time, self.data.capacity_perc)
        end)

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() self:update() end)
    ))

end

function BatWidget:updateIcon()
    local perc_nearest = tostring((math.floor((self.data.perc + 5) / 10) * 10))

    if self.data.ac_status == 1 then
        self:set_icon(icons["ac_" .. perc_nearest])
    else
        self:set_icon(icons["bat_" .. perc_nearest])
    end
end

function BatWidget:update()
    self.lainwidget.update()
end

return BatWidget
