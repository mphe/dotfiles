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
    end

    self.oldstatus = 1
    self.lainwidget = lain.widgets.bat(args)
    local box = self:init(self.lainwidget.widget, args.icon or icons.ac)

    utils.registerPopupNotify(box, "Battery", function(w)
            return string.format("Time remaining:\t%s", self.data.time)
        end)
end

function BatWidget:updateIcon()
    if self.data.ac_status == self.oldstatus then
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
