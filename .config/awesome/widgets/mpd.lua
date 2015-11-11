local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")

local M = {}

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

local function creator(args)
    local reg = {
        widget = wibox.layout.constraint(wibox.widget.textbox(), "max", 125, nil)
    }
    reg.vicwidget = vicious.register(reg.widget.widget, vicious.widgets.mpd, function(w, args)
        M.args = args
        if args["{state}"] == "Stop" then return "" end
        return args["{Title}"] == "N/A" and M.getFilename(args["{file}"]) or args["{Title}"]
    end, 3)
    return reg
end

function M.update(reg)
    vicious.force({ reg.widget })
end

function M.getFilename(fname)
    -- The '/' at the beginning of the filename ensures that the regex will also work for files
    -- in the root of the music directory (which don't have any '/' inside their filename).
    return ("/" .. fname):match(".*/(.*)")
end

function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("ncmpcpp -s visualizer") end),
        awful.button({}, 3, function() mpdmenu:toggle() end),
        awful.button({}, 4, function() awful.util.spawn("mpc volume +2") end),
        awful.button({}, 5, function() awful.util.spawn("mpc volume -2") end)
    ))

    utils.registerPopupNotify(widget, "MPD", function(w)
        return "Title:\t\t" .. M.args["{Title}"] ..
        "\nAlbum:\t" .. M.args["{Album}"] ..
        "\nArtist:\t" .. M.args["{Artist}"] ..
        "\nGenre:\t" .. M.args["{Genre}"] ..
        "\nFile:\t\t" .. M.getFilename(M.args["{file}"]) ..
        "\nState:\t" .. M.args["{state}"] ..
        "\nVolume:\t" .. tostring(M.args["{volume}"])
    end)
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
