local awful = require("awful")
local naughty = require("naughty")
local menubar = require("menubar")
local globals = require("globals")
local beautiful = require("beautiful")

local M = {}

local next = next

function M.table_empty(t)
    return next(t) == nil
end

-- I hate lua
function M.table_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function M.firstkey(t)
    for k, v in pairs(t) do -- luacheck: ignore
        return k, v
    end
    return nil
end

function M.get_screen_id(s)
    return tostring(s.geometry.width) .. "x" .. tostring(s.geometry.height) .. "x" .. tostring(M.firstkey(s.outputs))
end

function M.table_join(t, keychar, linechar)
    keychar = keychar or ": "
    linechar = linechar or "\n"
    local lines = {}

    for k, v in pairs(t) do
        table.insert(lines, string.format("%s%s%s", k, keychar, v))
    end

    return table.concat(lines, linechar)
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

function M.async_lines(cmd, callback, exit)
    awful.spawn.with_line_callback(cmd, { stdout = callback, exit = exit })
end

-- Open a terminal and run a command inside
function M.run_term(cmd, rules)
    awful.spawn.spawn(string.format(globals.terminal_cmd_format, cmd), rules)
end

-- Run the process if it isn't already running, otherwise kill it.
function M.toggle_run(cmd)
    awful.spawn.with_shell(string.format("pkill -u $USER -fnx \"%s\" || %s", cmd, cmd))
end

-- Same as above but open a terminal
function M.toggle_run_term(cmd)
    awful.spawn.with_shell(string.format("pkill -u $USER -fnx \"%s%s\" || %s",
        globals.terminal_cmd, cmd, string.format(globals.terminal_cmd_format, cmd)))
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
            text = text_ or "",
            title = title_,
            timeout = timeout_ or 1
        })
end

function M.debugtable(t, title)
    title = title or "Debug"
    local text = ""
    for k,v in pairs(t) do
        text = text .. tostring(k) .. " = " .. tostring(v) .. "\n"
    end
    M.notify(text, title, 0)
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

function M.menu_entry(title, program, icon_name)
    icon_name = icon_name or program
    return { title, program, beautiful.lookup_icon(icon_name) }
end


function M.do_placement(c)
    -- except rules
    if (c.class == "TelegramDesktop" and c.name == "Media viewer")
        or c.class == "Unity"
        or c.class == "jetbrains-studio"
        or c.class == "xpad" then
        return
    end

    local placement_rule = awful.placement.centered+awful.placement.no_offscreen

    if c.motif_wm_hints then
        -- local hint = c.motif_wm_hints.functions
        -- if hint then utils.debugtable(hint, "Functions") end
        -- hint = c.motif_wm_hints.decorations
        -- if hint then utils.debugtable(hint, "Deco") end

        local hint = c.motif_wm_hints.functions
        -- if not hint then
        --     hint = c.motif_wm_hints.decorations
        -- end

        if hint then
            local skip = hint.resize or hint.move or hint.maximize
            skip = skip ~= hint.all

            if skip then
                placement_rule(c)
                return
            end
        end
    end

    local sw = c.screen.workarea.width
    local sh = c.screen.workarea.height
    local cw = c:geometry().width
    local ch = c:geometry().height

    if ch > sh then
        cw = cw * sh / ch
        c:geometry({ height = sh, width = cw })
    end
    if cw > sw then
        local fac = sh / ch
        c:geometry({ width = sw, height = ch * fac })
    end

    placement_rule(c, { honor_workarea = true })
end


function M.Set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end
    return set
end


function M.StripANSI(str)
    return str:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", ""):gsub("[^%C\n\t]", "")
end

return M
