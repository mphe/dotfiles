local icondir = os.getenv("HOME") .. "/.config/awesome/icons/"

return {
    awesome         = "/usr/share/awesome/icons/awesome16.png",
    arch            = icondir .. "arch.png",
    cpu             = icondir .. "cpu.png",
    ac              = icondir .. "ac.png",
    bat             = icondir .. "bat_full_01.png",
    brightness      = icondir .. "brightness.png",
    mem             = icondir .. "mem.png",
    mpd             = icondir .. "note.png",
    temp            = icondir .. "temp.png",
    volume          = icondir .. "spkr_01.png",
    muted           = icondir .. "spkr_02.png",
    net_wired       = icondir .. "net_wired.png",
    net_wired_na    = icondir .. "net_wired_na.png",
    wifi            = {
        icondir .. "wifi_03.png",
        icondir .. "wifi_04.png",
        icondir .. "wifi_05.png",
        icondir .. "wifi_06.png"
    },
    wifi_na         = icondir .. "wifi_na.png",
    fs              = icondir .. "fs_03.png",
}
