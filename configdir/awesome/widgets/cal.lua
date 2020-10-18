local awful = require("awful")
local utils = require("utils")
local wibox = require("wibox")
local BaseWidget = require("widgets.base").BaseWidget

local CalendarWidget = BaseWidget.derive()

function CalendarWidget:create(args)
    args = args or {}

    local mytextclock = wibox.widget.textclock()
    local box = self:init(mytextclock, args.icon)

    box:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        local c = awful.spawn.raise_or_spawn("orage", {
            placement = awful.placement.top_right,
            ontop = true,
            requests_no_titlebar = true,
            titlebars_enabled = false,
            floating = true,
        }, nil, "awesome_orage_calender_widget")
        if c then
            c:kill()
        end
    end)
    ))
end

return CalendarWidget
