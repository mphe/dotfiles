local awful = require("awful")
local screen = screen

-- Takes a screenshot of the given screen or the whole screen when
-- passing -1 (default).
-- snum: screen number or -1 for whole screen or 0 for interactive select.
-- dir: the output directory (defaults to M.image_dir).

local M = {}

-- Default save directory
M.image_dir = "~"

-- Constants usable as `snum`
M.INTERACTIVE = 0  -- interactive region select
M.WHOLE_SCREEN = -1  -- screenshot whole screen

local function get_args(snum, dir)
    snum = snum or M.WHOLE_SCREEN
    if snum < 0 then
        snum = M.WHOLE_SCREEN
    end

    return snum, (dir or M.image_dir) .. "/screenshot$(date +%Y%m%d%H%M%S).png"
end

function M.screenshot_custom(snum, dir)
    snum, dir = get_args(snum, dir)
    local cmd = ""

    if snum >= 0 then
        if snum == M.INTERACTIVE then
            cmd = "-s"
        else
            local g = screen[snum].geometry
            cmd = string.format("--geometry=%ix%i+%i+%i", g.width, g.height, g.x, g.y)
        end

        cmd = cmd .. " --hidecursor"
    end
    awful.spawn.with_shell(string.format(
    -- os.getenv("HOME") ..  "/scripts/screenshot.sh %s -n 2 -c 1,1,1,0.1 --highlight %s", dir, cmd))
    os.getenv("HOME") ..  "/scripts/screenshot.sh %s -n 2 %s", dir, cmd))
end

function M.screenshot_maim(snum, dir)
    snum, dir = get_args(snum, dir)
    local cmd = ""

    if snum >= 0 then
        if snum == M.INTERACTIVE then
            cmd = "-s"
        else
            local g = screen[snum].geometry
            cmd = string.format("--geometry=%ix%i+%i+%i", g.width, g.height, g.x, g.y)
        end

        cmd = cmd .. " --hidecursor"
    end
    awful.spawn.with_shell(string.format(
        "maim -n 2 %s | tee \"%s\" | xclip -selection clipboard -t image/png", cmd, dir))
        -- "maim -n 2 -c 1,1,1,0.1 --highlight %s | tee \"%s\" | xclip -selection clipboard -t image/png", cmd, dir))
end

function M.screenshot_import(snum, dir)
    snum, dir = get_args(snum, dir)
    local cmd = "import "

    if snum < 0 then
        cmd = "import -window root "
    elseif snum > 0 then
        local g = screen[snum].geometry
        cmd = string.format("import -window root -crop %ix%i+%i+%i +repage ",
            g.width, g.height, g.x, g.y)
    end
    awful.spawn.with_shell(cmd .. dir)
end


-- function M.screenshot_flameshot(snum, dir)
--     snum, dir = get_args(snum, dir)
--     local cmd = ""
--
--     if snum == M.INTERACTIVE then
--         cmd = "gui"
--     elseif snum == M.WHOLE_SCREEN then
--         cmd = "full"
--     else
--         cmd = "screen "
--         local g = screen[snum].geometry
--         cmd = string.format("--geometry=%ix%i+%i+%i", g.width, g.height, g.x, g.y)
--     end
--
--     if snum >= 0 then
--
--     cmd = cmd .. " --hidecursor"
--     end
--     awful.spawn.with_shell(string.format(
--         "maim -n 2 -c 1,1,1,0.1 --highlight %s | tee \"%s\" | xclip -selection clipboard -t image/png", cmd, dir))
-- end

-- xfce4-screenshooter doesn't support screen selection
-- function M.screenshot_xfce(snum, dir)
--     snum, dir = get_args(snum, dir)
--     local cmd = ""
--
--     if snum == M.INTERACTIVE then
--         cmd = "-r"
--     elseif snum == M.WHOLE_SCREEN then
--         cmd = "-f"
--     else
--
--
--     if snum >= 0 then
--         cmd = cmd .. "--hidecursor "
--
--         if snum == 0 then
--             cmd = cmd .. "-s "
--         elseif snum > 0 then
--             local g = screen[snum].geometry
--             cmd = cmd .. string.format("--geometry=%ix%i+%i+%i ", g.width, g.height, g.x, g.y)
--         end
--     end
--     awful.spawn.with_shell(string.format("xfce4-screenshooter %s", cmd))
-- end

return M
