local wibox = require("wibox")
local configdir = os.getenv("HOME") .. "/.config/awesome"
local icondir = configdir .. "/icons/"

local M = {}

M.awesome = "/usr/share/awesome/icons/awesome16.png"
M.arch = icondir .. "arch.png"
M.cpu = icondir .. "cpu.png"
M.wifi = icondir .. "wifi_02.png"
M.bat = icondir .. "bat_full_02.png"
M.speaker = icondir .. "spkr_01.png"
M.brightness = icondir .. "brightness.png"
M.mem = icondir .. "mem.png"
M.mpd = icondir .. "note.png"

function M.loadIcon(icon)
    w = wibox.widget.imagebox()
    w:set_image(icon)
    return w
end

return M
