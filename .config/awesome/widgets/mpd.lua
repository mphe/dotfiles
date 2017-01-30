local awful = require("awful")
local utils = require("utils")
local lain = require("lain")
local wibox = require("wibox")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local MPDWidget = BaseWidget.derive()

local mpdmenu = awful.menu({
    items = {
        { "Play/Pause", "mpc toggle" },
        { "Stop", "mpc stop" },
        { "Next", "mpc next" },
        { "Previous", "mpc prev" },
        { "Toggle random", "mpc random" },
        { "Toggle repeat", "mpc repeat" },
        { "Toggle single", "mpc single" },
    },
    theme = { width = 120 }
})

-- Strips the path part from the filename
local function getFilename(fname)
    -- The '/' at the beginning of the filename ensures that the regex will
    -- also work for files in the root of the music directory (which don't
    -- have any '/' inside their filename).
    return ("/" .. fname):match(".*/(.*)")
end

local function prettyTime(seconds)
    if not seconds then
        return -1
    end
    local sec = (seconds % 60)
    return math.floor(seconds / 60) .. ":" .. (sec < 10 and "0" or "") .. sec
end

function MPDWidget:create(args)
    args = args or {}
    args.settings = function() self:updateText() end

    self.lainwidget = lain.widgets.mpd(args)
    local widget = wibox.container.constraint(self.lainwidget.widget, "max", 125, nil)
    widget.widget:set_align("right")

    local box = self:init(widget, args.icon or icons.mpd)
    self:attach(box)
end

function MPDWidget:update()
    self.lainwidget.update()
end

function MPDWidget:updateText()
    self.data = mpd_now
    if mpd_now.state == "stop" then
        widget:set_markup("")
        return
    elseif mpd_now.title == "N/A" then
        widget:set_markup(getFilename(self.data.file))
    else
        widget:set_markup(mpd_now.title)
    end
end

function MPDWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("ncmpcpp -s visualizer") end),
        awful.button({}, 3, function() mpdmenu:toggle() end),
        awful.button({}, 4, function() awful.spawn("mpc volume +2") end),
        awful.button({}, 5, function() awful.spawn("mpc volume -2") end)
    ))

    utils.registerPopupNotify(box, "MPD", function(w)
        return "Title:\t\t" .. self.data.title ..
        "\nAlbum:\t" .. self.data.album ..
        "\nArtist:\t" .. self.data.artist ..
        "\nGenre:\t" .. self.data.genre ..
        "\nFile:\t\t" .. getFilename(self.data.file) ..
        "\nState:\t" .. self.data.state ..
        "\nLength:\t" .. prettyTime(tonumber(self.data.time))
    end)
end

return MPDWidget
