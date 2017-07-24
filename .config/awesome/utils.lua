local awful = require("awful")
local naughty = require("naughty")

local M = {}

-- Takes a screenshot of the given screen or the whole screen when
-- passing -1 (default).
-- snum: screen number or -1 for whole screen or 0 for interactive select.
-- dir: the output directory (defaults to ~/img).
function M.screenshot(snum, dir)
    snum = snum or -1
    local path = (dir or "~/img") .. "/screenshot$(date +%Y%m%d%H%M%S).png"
    local cmd = "import "

    if snum < 0 then
        cmd = "import -window root "
    elseif snum > 0 then
        local g = screen[snum].geometry
        cmd = string.format("import -window root -crop %ix%i+%i+%i +repage ",
            g.width, g.height, g.x, g.y)
    end
    awful.spawn.with_shell(cmd .. path)
end

function M.file_exists(fname)
    local f = io.open(fname, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

-- Read a number from a file and return it. If it fails, def is returned.
function M.read_number(fname, def)
    return M.read(fname, def, "n")
end

-- Read a value from a file and return it. If it fails, def is returned.
function M.read(fname, def, val)
    local f = io.open(fname)
    if f then
        local d = f:read(val or "*line")
        f:close()
        return d or def
    end
    return def
end

function M.async(cmd, callback)
    awful.spawn.easy_async(cmd, function(stdout, stderr, exitreason, exitcode)
        callback(stdout)
    end)
end

function M.async_lines(cmd, callback)
    awful.spawn.with_line_callback(cmd, { stdout = function(line) callback(line) end })
end

-- Open a terminal and run a command inside
function M.run_term(cmd)
    awful.spawn.spawn(terminal_cmd .. "\"" .. cmd .. "\"")
end

-- Run the process if it isn't already running, otherwise kill it.
function M.toggle_run(cmd)
    awful.spawn.with_shell("pkill -u $USER -fnx \"" .. cmd .. "\" || " .. cmd)
end

-- Same as above but open a terminal
function M.toggle_run_term(cmd)
    awful.spawn.with_shell("pkill -u $USER -fnx \"" .. terminal_cmd .. cmd .. "\" || " .. terminal_cmd .. "\"" .. cmd .. "\"")
end

-- Add mouse enter/leave signal to a widget.
-- When the user hovers over the widget it shows a notifications with the
-- text that <callback> returns.
-- <callback> is a function that accepts a widget as argument.
-- It adds the field _notification to the widget to store the notification object.
function M.registerPopupNotify(widget, title, callback)
    widget:connect_signal('mouse::enter', function()
        widget._notification = M.notify(callback(widget), title, 0)
    end)
    widget:connect_signal('mouse::leave', function()
        naughty.destroy(widget._notification)
        widget._notification = nil
    end)
end

-- Wrapper for naughty.notify
function M.notify(text_, title_, timeout_)
    return naughty.notify({
            text = text_,
            title = title_ or "",
            timeout = timeout_ or 1
        })
end

function M.debugtable(t)
    local text = ""
    for k,v in pairs(t) do
        text = text .. tostring(k) .. " = " .. tostring(v) .. "\n"
    end
    M.notify(text, "Debug", 0)
end

-- Move/Resize a client relative.
-- Works for both, floating and non-floating clients.
function M.moveresize(x, y, w, h, c)
    if c and c.floating then
        c:relative_move(x, y, w * 15, h * 15, c)
    else
        if w ~= 0 then
            awful.tag.incmwfact(w * 0.01)
        end
        if h ~= 0 then
            awful.client.incwfact(h * 0.05, c)
        end
    end
end

return M
