local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")

local M = {}

function M.file_exists(fname)
    local f = io.open(fname, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Wrapper for naughty.notify to use mouse.screen as default screen
function M.notify(args)
    args.screen = args.screen or mouse.screen
    return naughty.notify(args)
end

function M.debugtable(t)
    local text = ""
    for k,v in pairs(t) do
        text = text .. tostring(k) .. " = " .. tostring(v) .. "\n"
    end
    M.notify({
        title = "Debug",
        text = text,
        timeout = 0
    })
end

function M.run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- Open a terminal and run a command inside
function M.run_term(cmd)
    awful.util.spawn(terminal_cmd .. "\"" .. cmd .. "\"")
end

-- Run the process if it isn't already running, otherwise kill it.
function M.toggle_run(cmd)
    awful.util.spawn_with_shell("pkill -u $USER -fnx \"" .. cmd .. "\" || " .. cmd)
end

-- Same as above but open a terminal
function M.toggle_run_term(cmd)
    awful.util.spawn_with_shell("pkill -u $USER -fnx \"" .. terminal_cmd .. cmd .. "\" || " .. terminal_cmd .. "\"" .. cmd .. "\"")
end


-- Add mouse enter/leave signal to a widget.
-- When the user hovers over the widget it shows a notifications with the text that <callback> returns.
-- <callback> is a function that accepts a widget as argument.
-- It adds the field __notification to the widget to store the notification object.
function M.registerPopupNotify(widget, title, callback)
    widget:connect_signal('mouse::enter', function()
        widget.__notification = M.notify({
            title = title,
            text = callback(widget),
            timeout = 0
        })
    end)
    widget:connect_signal('mouse::leave', function()
        naughty.destroy(widget.__notification)
        widget.__notification = nil
    end)
end

return M
