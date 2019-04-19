local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local TempWidget = BaseWidget.derive()

function TempWidget:create(args)
    args = args or {}
    args.critical = args.critical or 80
    args.critcolor = args.critcolor or "#FF0000"
    args.settings = function()
        local t = coretemp_now
        if t >= args.critical then
            widget:set_markup(string.format('<span color="%s">%s°C</span>',
                args.critcolor, coretemp_now))
        else
            widget:set_markup(t .. "°C")
        end
    end

    local box = self:init(lain.widgets.temp(args), args.icon or icons.temp)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run("psensor") end)
    ))
end

return TempWidget
