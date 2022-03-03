local icondir = os.getenv("HOME") .. "/.config/awesome/icons/"
local beautiful = require("beautiful")

local icons      = {
    awesome      = "/usr/share/awesome/icons/awesome16.png",
    arch         = icondir .. "arch.png",
    endeavouros  = icondir .. "endeavouros.png",
    cpu          = beautiful.lookup_icon_colored(icondir .. "cpu2.svg"),
    -- cpu          = icondir .. "cpu.png",
    mem          = icondir .. "mem.png",
    ac           = beautiful.lookup_icon_colored("devices/ac-adapter"),
    bat          = beautiful.lookup_icon_colored("devices/battery"),
    mpd          = beautiful.lookup_icon_colored("status/mpi"),
    temp         = beautiful.lookup_icon_colored("status/sensors-temperature"),
    temp_crit    = beautiful.lookup_icon_colored("status/sensors-temperature", "#ff0000"),
    muted        = beautiful.lookup_icon_colored("status/audio-volume-muted"),
    fs           = beautiful.lookup_icon_colored("devices/drive-harddisk"),
    -- fs            = beautiful.lookup_icon_colored("devices/drive-multidisk"),
    net_wired    = beautiful.lookup_icon_colored("status/network-wired"),
    net_wired_na = beautiful.lookup_icon_colored("status/network-wired-disconnected"),
    wifi_na      = beautiful.lookup_icon_colored("status/network-wireless-disconnected"),
    wifi         = {
        beautiful.lookup_icon_colored("status/network-wireless-signal-weak"),
        beautiful.lookup_icon_colored("status/network-wireless-signal-ok"),
        beautiful.lookup_icon_colored("status/network-wireless-signal-good"),
        beautiful.lookup_icon_colored("status/network-wireless-signal-excellent"),
    },
    nvidia = beautiful.lookup_icon_colored("status/nvidia-card"),
    nvidia_green = beautiful.lookup_icon_colored("status/nvidia-card", "#00aa00"),
}

-- Adds entries <basename>_<level> to `icons` table with icon paths according to strformat.
local function generate(basename, file_strformat, levels)
    file_strformat = file_strformat or basename .. "-%s"  -- %s replaced with each entry in `levels`
    for _, level in ipairs(levels) do
        local fname = string.format(file_strformat, level)
        local icon = beautiful.lookup_icon_colored(fname)

        if icon then
            local key = string.format("%s_%s", basename, level)
            icons[key] = icon
        end
    end
end

local function generate_3level(basename, file_basename)
    generate(basename, file_basename .. "-%s", { "high", "medium", "low" })
end

generate_3level("brightness", "status/display-brightness")
generate_3level("volume", "status/audio-volume")

generate("bat", "status/battery-level-%s", { "0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100" })
generate("ac", "status/battery-level-%s-charging", { "0", "10", "20", "30", "40", "50", "60", "70", "80", "90", })

-- Filename battery-level-100-charged instead of battery-level-100-charging
icons["ac_100"] = beautiful.lookup_icon_colored("status/battery-level-100-charged")

-- Returns the corresponding X-{low,medium,high} icon
function icons.get_3level(iconname, value)
    if value < 33 then
        return icons[iconname .. "_low"]
    elseif value < 66 then
        return icons[iconname .. "_medium"]
    else
        return icons[iconname .. "_high"]
    end
end

return icons


-- return {
--     awesome         = "/usr/share/awesome/icons/awesome16.png",
--     arch            = icondir .. "arch.png",
--     endeavouros     = icondir .. "endeavouros.png",
--     cpu             = icondir .. "cpu.png",
--     ac              = icondir .. "ac.png",
--     bat             = icondir .. "bat_full_01.png",
--     brightness      = icondir .. "brightness.png",
--     mem             = icondir .. "mem.png",
--     mpd             = icondir .. "note.png",
--     temp            = icondir .. "temp.png",
--     volume          = icondir .. "spkr_01.png",
--     muted           = icondir .. "spkr_02.png",
--     net_wired       = icondir .. "net_wired.png",
--     net_wired_na    = icondir .. "net_wired_na.png",
--     wifi            = {
--         icondir .. "wifi_03.png",
--         icondir .. "wifi_04.png",
--         icondir .. "wifi_05.png",
--         icondir .. "wifi_06.png"
--     },
--     wifi_na         = icondir .. "wifi_na.png",
--     fs              = icondir .. "fs_03.png",
-- }
