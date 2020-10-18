local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local BatWidget = BaseWidget.derive()

function BatWidget:create(args)
    args = args or {}
    args.settings = function()
        widget:set_markup(bat_now.perc .. "%")
        self.data = bat_now
        self:updateIcon()

        -- Calculate wear level
        -- TODO: Consider adding this in lain and create a pull request
        local batpath = "/sys/class/power_supply/" .. (args.battery or "BAT1")
        local charge_full = utils.read_number(batpath .. "/charge_full", 0)
        local charge_full_design = utils.read_number(batpath .. "/charge_full_design", nil)

        if not charge_full_design or charge_full_design == 0 then
            self.data.wear_perc = "N/A"
        else
            self.data.wear_perc = math.floor((charge_full / charge_full_design) * 100)
        end
    end

    self.oldstatus = 1
    self.lainwidget = lain.widget.bat(args)
    local box = self:init(self.lainwidget.widget, args.icon or icons.ac)
    self:updateIcon(true)

    utils.registerPopupNotify(box, "Battery", function(w)
            return string.format("Time remaining:\t%s\nWear Level:\t%s%%",
                self.data.time, self.data.wear_perc)
        end)

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() self:update() end)
    ))

end

function BatWidget:updateIcon(force)
    force = force or false
    if not force and self.data.ac_status == self.oldstatus then
        return
    elseif self.data.ac_status == 1 then
        self:set_icon(icons.ac)
    else
        self:set_icon(icons.bat)
    end
    self.oldstatus = self.data.ac_status
end

function BatWidget:update()
    self.lainwidget.update()
end

return BatWidget
