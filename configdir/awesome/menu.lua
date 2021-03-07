local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local globals = require("globals")
local utils = require("utils")
local freedesktop = require("freedesktop")

-- keep the linter happy regarding awesome globals
-- luacheck: globals awesome

local home = os.getenv("HOME")

-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", function() utils.run_term("man awesome") end },
   { "edit config", function() utils.run_term(globals.editor .. " " .. awesome.conffile) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local systemmenu = {
    utils.menu_entry("Lock", home .. "/scripts/lockscreen.sh", "system-lock-screen"),
    utils.menu_entry("Poweroff", "systemctl poweroff", "system-shutdown"),
    utils.menu_entry("Reboot", "systemctl reboot", "system-reboot"),
    utils.menu_entry("Suspend", "systemctl suspend", "system-suspend"),
    utils.menu_entry("Hibernate", "systemctl hibernate", "system-hibernate"),
}

local mymainmenu = freedesktop.menu.build({
    sub_menu = "Applications",
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "System", systemmenu },
    },
    after = {
        utils.menu_entry("Terminal", globals.terminal, "terminal"),
        utils.menu_entry("File Manager", globals.filemgr),
        utils.menu_entry("Firefox", "firefox"),
        utils.menu_entry("Thunderbird", "thunderbird"),
        utils.menu_entry("System Monitor", "xfce4-taskmanager", "utilities-system-monitor"),
        utils.menu_entry("Kill Process", home .."/scripts/killprompt.sh"),
        utils.menu_entry("Screenshot", "xfce4-screenshooter", "accessories-screenshot"),
        { "Restart desktop", function() awful.spawn.with_shell("xfdesktop -Q && xfdesktop --sm-client-disable --disable-wm-check") end },  -- luacheck: ignore
        { "Restart picom", function() awful.spawn.with_shell("killall picom; sleep 1; picom -b") end },  -- luacheck: ignore
    }
})

mymainmenu.theme.width = beautiful.main_menu_width

return mymainmenu
