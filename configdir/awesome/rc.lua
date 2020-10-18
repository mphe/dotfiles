-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Includes {{{
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
local utils = require("utils")
local icons = require("icons")
local cal = require("cal")
local widgets = require("widgets")
local systray = require("systray")
local treetile = require("treetile")
treetile.focusnew = true
local freedesktop = require("freedesktop")
local screenshot = require("screenshot")

-- keep the linter happy regarding awesome globals
local mouse = mouse
local awesome = awesome
local client = client
local screen = screen
local tag = tag
local root = root

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
-- Keep them global because they're used in utils module.
local terminal = "alacritty"
terminal_cmd = terminal .. " -e "
terminal_cmd_format = terminal_cmd .. "%s"
shell = "bash"
-- terminal_cmd_format = terminal_cmd .. "\"%s\""
local editor = os.getenv("EDITOR") or "vim"
local filemgr = "nemo"
local home = os.getenv("HOME")
local configdir = home .. "/.config/awesome"
local scrot_tool = screenshot.screenshot_custom
screenshot.image_dir = "~/Schreibtisch"

local layoutconfig = nil
-- Config file for temporary/frequently changing layouts (untracked by git)
if utils.file_exists(configdir .. "/layoutconfig.lua") then
    layoutconfig = require("layoutconfig")
end

-- Default modkey.
local modkey = "Mod4"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(configdir .. "/themes/custom/theme.lua")
-- utils.debugtable(beautiful.gtk.get_theme_variables())

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    treetile
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", function() utils.run_term("man awesome") end },
   { "edit config", function() utils.run_term(editor .. " " .. awesome.conffile) end },
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
        utils.menu_entry("Terminal", terminal, "terminal"),
        utils.menu_entry("File Manager", filemgr),
        utils.menu_entry("Firefox", "firefox"),
        utils.menu_entry("Thunderbird", "thunderbird"),
        utils.menu_entry("System Monitor", "xfce4-taskmanager", "utilities-system-monitor"),
        utils.menu_entry("Kill Process", home .."/scripts/killprompt.sh"),
        utils.menu_entry("Screenshot", "xfce4-screenshooter", "accessories-screenshot"),
        { "Restart desktop", function() awful.spawn.with_shell("killall xfdesktop && xfdesktop --disable-wm-check") end },  -- luacheck: ignore
    }
})
mymainmenu.theme.width = 150

local mylauncher = awful.widget.launcher({
    image = icons.arch,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Create a wibox for each screen and add it {{{
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)
-- }}}

-- task list {{{
local tasklist_buttons = awful.util.table.join(
     awful.button({ }, 1, function(c)
         -- local abovec = awful.client.next(-1, c, true)
         -- if abovec then
         --     utils.notify(abovec.name)
         -- end
         if c == client.focus then
             c.minimized = true
         else
             -- Without this, the following :isvisible() makes no sense
             c.minimized = false
             if not c:isvisible() and c.first_tag then
                 c.first_tag:view_only()
             end
             -- This will also un-minimize the client, if needed
             client.focus = c
             c:raise()
         end
     end),
     awful.button({ }, 2, function(c) c:kill() end),
     awful.button({ }, 3, client_menu_toggle_fn()),
     awful.button({ }, 4, function() awful.client.focus.byidx(1) end),
     awful.button({ }, 5, function() awful.client.focus.byidx(-1) end)
)
-- }}}

-- Widgets {{{
-- Include here because it requires beautiful theme to be initialized
local todo_widget = require("todo")

local separator = wibox.widget.textbox()
separator:set_text("  ")

local systraywidget = systray()
systraywidget:toggle() -- Hide the systray
local cpuwidget = widgets.cpu({ timeout = 3 })
local memwidget = widgets.mem({ timeout = 3 })
local volwidget = widgets.volume({ timeout = 5 })
local batwidget = widgets.bat({ timeout = 61, battery = "BAT1", ac = "ACAD", n_perc = {5, 10}, full_notify = "off" })
local tempwidget = widgets.temp({ timeout = 59, })
local mpdwidget = widgets.mpd({ timeout = 3, notify = "off" })
local brightwidget = widgets.brightness()
local wiredwidget = widgets.wired({ autohide = true })
local wifiwidget = widgets.wifi({ autohide = true })
local fswidget = widgets.fs()
local minwidget = widgets.minimize()
local todowidget = todo_widget()
local vpnwidget = widgets.nordvpn()
-- todowidget = widgets.todo()

-- local mytextclock = widgets.cal()
local mytextclock = wibox.widget.textclock()
cal.register(mytextclock)

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()
-- }}}

-- Setup screens {{{
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.centered(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Restore tags {{{
    -- https://stackoverflow.com/questions/42056795/awesomewm-how-to-prevent-migration-of-clients-when-screen-disconnected
    -- Check if existing tags belong to this new screen that's being added
    local restored = {}
    local all_tags = root.tags()
    for _, t in pairs(all_tags) do
        if utils.get_screen_id(s) == t.screen_id then
            t.screen = s
            table.insert(restored, t)
        end
    end

    -- Create tags 1-9 but skip tags that were already restored
    for i = 1,9 do
        local istr = tostring(i)
        if not restored[istr] then
            local t = awful.tag.add(istr, {
                screen = s,
                layout = awful.layout.layouts[2]
            })
            t.screen_id = utils.get_screen_id(s)
        end

        -- Each screen has its own tag table.
        -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[2])

        -- Assign the tag to this screen, to restore as the screen disconnects/connects
        -- for _, t in pairs(s.tags) do
        --     t.screen_id = utils.get_screen_id(s)
        -- end
    end

    -- On restored screen, select a tag
    -- if not utils.table_empty(restored) then
    local _, v = utils.firstkey(s.tags)
    v.selected = true
    -- end
    -- }}}

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
       awful.button({ }, 1, function () awful.layout.inc( 1) end),
       awful.button({ }, 3, function () awful.layout.inc(-1) end),
       awful.button({ }, 4, function () awful.layout.inc( 1) end),
       awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            systraywidget.widget,
            separator,
            mpdwidget:get_container(),
            separator,
            todowidget,
            -- todowidget:get_container(),
            separator,
            vpnwidget:get_container(),
            -- separator,
            wifiwidget:get_container(),
            wiredwidget:get_container(),
            -- separator,
            fswidget:get_container(),
            separator,
            brightwidget:get_container(),
            separator,
            tempwidget:get_container(),
            separator,
            volwidget:get_container(),
            separator,
            batwidget:get_container(),
            separator,
            memwidget:get_container(),
            separator,
            cpuwidget:get_container(),
            separator,
            mytextclock,
            -- mytextclock:get_container(),
            s.mylayoutbox,
            minwidget:get_container()
        },
    }

    -- Apply custom config
    if layoutconfig then
        layoutconfig(s)
    end
end)

tag.connect_signal("request::screen", function(t)
    -- Screen has disconnected, re-assign orphan tags to a live screen
    -- Don't carry tag over if it's empty
    if utils.table_length(t:clients()) == 0 then
        return
    end

    -- Don't carry tag over if it was already moved
    if utils.get_screen_id(t.screen) ~= t.screen_id then
        return
    end

    for s in screen do
        if s ~= t.screen then
            -- Move the orphaned tag to the live screen
            t.screen = s
            break
        end
    end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local function switch_focus(dir)
    awful.client.focus.global_bydirection(dir)
    if client.focus then client.focus:raise() end
end

-- Global keys {{{
local globalkeys = awful.util.table.join(
    -- awful.key({ modkey }, "s",      hotkeys_popup.show_help, {description="show help", group="awesome"}),

    awful.key({ "Mod1"          }, "Tab",
        function()
            local filter = function(c)
                return not c.minimized
            end

            local f = client.focus
            if f then
                for c in awful.client.iterate(filter, f.index, f.screen) do
                    client.focus = c
                    c:raise()
                end
            end
        end,
        { description = "cycle through clients", group = "client" }),

    -- Media keys {{{
    awful.key({ }, "XF86MonBrightnessDown", function() brightwidget:incBrightness(-5) end,
              { description = "decrease brightness", group = "media" }),

    awful.key({ }, "XF86MonBrightnessUp", function() brightwidget:incBrightness(5) end,
              { description = "increase brightness", group = "media" }),

    awful.key({}, "XF86AudioRaiseVolume", function() volwidget:changeVolume("1dB+") end,
              { description = "raise volume", group = "media" }),

    awful.key({}, "XF86AudioLowerVolume", function() volwidget:changeVolume("1dB-") end,
              { description = "lower volume", group = "media" }),

    awful.key({}, "XF86AudioMute", function() volwidget:toggleMute() end,
              { description = "mute", group = "media" }),

    awful.key({}, "XF86AudioStop", function()
            utils.async("mpc --wait stop", function(out) mpdwidget:update() end)
        end,
        { description = "stop", group = "media" }),

    awful.key({}, "XF86AudioNext", function()
            utils.async("mpc --wait next", function(out) mpdwidget:update() end)
        end,
        { description = "next", group = "media" }),

    awful.key({}, "XF86AudioPrev", function()
            utils.async("mpc --wait prev", function(out) mpdwidget:update() end)
        end,
        { description = "previous", group = "media" }),

    awful.key({}, "XF86AudioPlay", function() awful.spawn("mpc toggle") end,
        { description = "toggle play/pause", group = "media" }),
    -- }}}

    -- Screenshot
    awful.key({ },         "Print", function() scrot_tool(mouse.screen.index) end,
              { description = "current screen", group = "screenshot" }),
    awful.key({ "Shift" }, "Print", function() scrot_tool(screenshot.WHOLE_SCREEN) end,
              { description = "all screens", group = "screenshot" }),
    awful.key({ modkey },  "Print", function() scrot_tool(screenshot.INTERACTIVE) end,
              { description = "selection", group = "screenshot" }),

    -- Open file explorer
    awful.key({ modkey }, "e", function() awful.spawn(filemgr) end,
              { description = "open file explorer", group = "launcher" }),
    awful.key({ modkey , "Shift" }, "e", function() awful.spawn.with_shell("urxvt -e python3 $(which ranger)") end,
              { description = "open ranger in urxvt", group = "launcher" }),

    -- Focus {{{
    awful.key({ modkey }, "Left",   awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "Right",  awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

    awful.key({ modkey }, "j", function() switch_focus("down") end,
        { description = "focus below", group = "client" }),
    awful.key({ modkey }, "k", function() switch_focus("up") end,
        { description = "focus above", group = "client" }),
    awful.key({ modkey }, "h", function() switch_focus("left") end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l", function() switch_focus("right") end,
        { description = "focus right", group = "client" }),

    awful.key({ modkey, "Mod5" }, "j", function() awful.screen.focus_relative( 1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Mod5" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),

    awful.key({ modkey }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),
    -- }}}

    -- Layout manipulation
    -- In-/Decrease num master/column {{{
    awful.key({ modkey, "Control" }, "k",
        function()
            awful.tag.incnmaster(1, nil, true)
            utils.notify(tostring(awful.tag.getnmaster()), "Master")
        end,
        { description = "increase the number of master clients", group = "layout" }),

    awful.key({ modkey, "Control" }, "j",
        function()
            awful.tag.incnmaster(-1, nil, true)
            utils.notify(tostring(awful.tag.getnmaster()), "Master")
        end,
        { description = "decrease the number of master clients", group = "layout" }),

    awful.key({ modkey, "Control" }, "h",
        function()
            awful.tag.incncol(1, nil, true)
            utils.notify(tostring(awful.tag.getncol()), "Columns")
        end,
        { description = "increase the number of columns", group = "layout" }),

    awful.key({ modkey, "Control" }, "l",
        function()
            awful.tag.incncol(-1, nil, true)
            utils.notify(tostring(awful.tag.getncol()), "Columns")
        end,
        { description = "decrease the number of columns", group = "layout" }),
    -- }}}

    awful.key({ modkey,           }, "space", function() awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    -- Standard program
    awful.key({ modkey }, "w", function() mymainmenu:show() end,
              { description = "show main menu", group = "awesome" }),

    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
              { description = "open a terminal", group = "launcher" }),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              { description = "reload awesome", group = "awesome" }),

    awful.key({ modkey, "Shift"   }, "q", function()
        if os.getenv("XDG_CURRENT_DESKTOP") == "LXDE" then
            awful.spawn("lxsession-logout")
        else
            awesome.quit()
        end
    end, { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.global_bydirection("down") end,
        { description = "swap with client below", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.global_bydirection("up") end,
        { description = "swap with client above", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.client.swap.global_bydirection("left") end,
        { description = "swap with client left", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.client.swap.global_bydirection("right") end,
        { description = "swap with client right", group = "client" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),

    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --     { description = "show the menubar", group = "launcher" }),

    awful.key({ modkey }, "p", function() awful.spawn("albert show") end,
        { description = "open application launcher", group = "launcher" }),

    -- Toggle systray visibility
    awful.key({ modkey, "Control" }, "s", function() systraywidget:toggle() end,
              { description = "toggle systray visibility", group = "media" })
)
-- }}}

-- Client keys {{{
local clientkeys = awful.util.table.join(
    -- Remap close shortcut
    awful.key({ "Mod1" }, "F4", function(c) c:kill() end),
    awful.key({ modkey }, "F4", function(c) c:kill() end),
    awful.key({ modkey }, "c",  function(c) c:kill() end),
    awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end, {description = "close", group = "client"}),

    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey, "Control" }, "Return",
              function(c)
                  local o = awful.client.focus.history.get(mouse.screen, 1)
                  if o then
                      c:swap(o)
                      awful.client.focus.history.previous()
                  end
              end,
              {description = "switch with previously focused client", group = "client"}),

    awful.key({ modkey, "Control" }, "space", function(c)
            c.floating = not c.floating
            if c.floating and not (c.maximized_horizontal or c.maximized_vertical) then
                (awful.placement.no_offscreen+awful.placement.centered)(c, nil)
            end
            c:raise()
        end,
        { description = "toggle floating", group = "client" }),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),

    awful.key({ modkey, "Mod1" }, "m", function(c)
            c.maximized_vertical   = not c.maximized_vertical
            c:raise()
        end,
        { description = "maximize vertical", group = "client" }),

    awful.key({ modkey, "Mod1" }, "n", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "maximize horizontal", group = "client" }),

    awful.key({ modkey, "Mod1" }, "l", function(c) utils.moveresize(0, 0, 1, 0, c) end,
              { description = "Decrease width", group = "client" }),
    awful.key({ modkey, "Mod1" }, "h", function(c) utils.moveresize(0, 0, -1, 0, c) end,
              { description = "Increase width", group = "client" }),
    awful.key({ modkey, "Mod1" }, "j", function(c) utils.moveresize(0, 0, 0, 1, c) end,
              { description = "Increase height", group = "client" }),
    awful.key({ modkey, "Mod1" }, "k", function(c) utils.moveresize(0, 0, 0, -1, c) end,
              { description = "Decrease height", group = "client" }),

    awful.key({ modkey, "Mod1", "Shift" }, "l", function(c) utils.moveresize(15, 0, 0, 0, c) end,
              { description = "Move left", group = "client" }),
    awful.key({ modkey, "Mod1", "Shift" }, "h", function(c) utils.moveresize(-15, 0, 0, 0, c) end,
              { description = "Move right", group = "client" }),
    awful.key({ modkey, "Mod1", "Shift" }, "j", function(c) utils.moveresize(0, 15, 0, 0, c) end,
              { description = "Move down", group = "client" }),
    awful.key({ modkey, "Mod1", "Shift" }, "k", function(c) utils.moveresize(0, -15, 0, 0, c) end,
              { description = "Move up", group = "client" })
)
-- }}}

-- Tag keys {{{
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local t = awful.screen.focused().tags[i]
                        if t then
                           t:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local t = awful.screen.focused().tags[i]
                      if t then
                         awful.tag.viewtoggle(t)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local t = client.focus.screen.tags[i]
                          if t then
                              client.focus:move_to_tag(t)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local t = client.focus.screen.tags[i]
                          if t then
                              client.focus:toggle_tag(t)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"}),
        -- View tag on all screens.
        awful.key({ modkey , "Mod5" }, "#" .. i + 9,
                  function ()
                      for s in screen do
                          local t = s.tags[i]
                          if t then
                              t:view_only()
                          end
                      end
                  end,
                  { description = "switch to tag #" .. i .. " on all screens", group = "tag" })
    )
end
-- }}}

local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        client.focus = c
        c:raise()

        -- Resize clients by dragging at bottom left/right corner
        -- Radius is set in theme variable `client_corner_resize_radius`

        if not c.floating then
            return
        end

        -- Only use bottom left/right corner, because dragging titlebar is already mapped to move
        local corners = {
            { c.x + c.width, c.y + c.height },
            { c.x, c.y + c.height },
        }
        local m = mouse.coords()

        for _, pos in ipairs(corners) do
            if math.sqrt((m.x - pos[1]) ^ 2 + (m.y - pos[2]) ^ 2) <= beautiful.client_corner_resize_radius then
                awful.mouse.client.resize(c)
                break
            end
        end
    end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- Rules {{{
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule. {{{
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     floating = true,  -- Make all clients floating
                     -- size_hints_honor = false,
                     -- placement = awful.placement.no_overlap+awful.placement.centered+awful.placement.no_offscreen,
                     placement = function(c)
                         -- except rules
                         if c.class == "TelegramDesktop" and c.name == "Media viewer" then
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
                     end,
                 }
    }, -- }}}

    -- Make non-floating {{{
    {
        rule_any = {
            class = {
                "Alacritty",
                "Mate-terminal",
                "XTerm",
                "Termite",
                "URxvt",
                -- "Firefox",
                -- "firefox",
                "Chromium",
                -- "Navigator",
                "TelegramDesktop",
                "discord",
                "Zathura",
            },
            instance = {
                "Unity",
                "Navigator", -- firefox
            }
        },
        except_any = {
            instance = "Prompt",
            type = { "dialog" },
            name = { "Unity Package Manager", "Starting Unity..." },
        },
        properties = {
            floating = false,
            size_hints_honor = false,
        }
    }, -- }}}

    -- Desktop {{{
    {
        rule_any = { type = { "desktop" } },
        callback = function(c)
            c.screen = awful.screen.getbycoord(0, 0)
            end,
        properties = {
            sticky = true,
            border_width = 0,
            skip_taskbar = true,
            keys = {},
        }
    }, -- }}}

    {
        rule_any = { class = { "Synapse", "albert" } },
        properties = {
            border_width = 0,
        }
    }
}
-- }}}


local function checktitlebar(c)
    if c.floating and not c.maximized and not c.requests_no_titlebar then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end

    if c.floating and not c.maximized and not c.fullscreen then
        awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 1")
    else
        awful.spawn("xprop -id " .. c.window .. " -f _COMPTON_SHADOW 32c -set _COMPTON_SHADOW 0")
    end
end


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    checktitlebar(c)
end)

-- Add titlebars to floating windows
client.connect_signal("property::floating", checktitlebar)

-- Hide titlebar when maximized
-- Needs request::geometry because when property::maximized is called,
-- the window was already transformed, not filling up the space freed by hiding titlebar.
client.disconnect_signal("request::geometry", awful.ewmh.geometry)
client.connect_signal("request::geometry", function(c, ...)
    checktitlebar(c)
    return awful.ewmh.geometry(c, ...)
end)


-- Double click titlebar
-- https://www.reddit.com/r/awesomewm/comments/fesopj/double_clicking_titlebar/
local double_click_timer = nil

local function double_click_event_handler()
    if double_click_timer then
        double_click_timer:stop()
        double_click_timer = nil
        return true
    end

    double_click_timer = gears.timer.start_new(0.20, function()
        double_click_timer = nil
        return false
    end)
end


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()

            if double_click_event_handler() then
                c.maximized = not c.maximized
            else
                awful.mouse.client.move(c)
            end
        end),
        awful.button({ }, 2, function()
            c:kill()
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { position = "top", size = beautiful.titlebar_size }) : setup {
        { -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                layout  = wibox.layout.fixed.horizontal
            },
            buttons = buttons,
            margins = beautiful.titlebar_margin,
            widget = wibox.container.margin
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                -- awful.titlebar.widget.stickybutton   (c),
                -- awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            margins = beautiful.titlebar_margin,
            widget = wibox.container.margin
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- tag.connect_signal("request::screen", function(t)
--     local targetscreen = nil
--     -- utils.debugtable(t.screen, "Screen removed")
--
--     -- Find suitable screen
--     for s in screen do
--         if s ~= t.screen then
--             -- targetscreen = s
--             if
--                     -- s.geometry.x == t.screen.geometry.x and
--                     -- s.geometry.y == t.screen.geometry.y and
--                     s.geometry.width == t.screen.geometry.width and
--                     s.geometry.height == t.screen.geometry.height then
--                 targetscreen = s
--                 -- utils.debugtable(s, "Screen found")
--                 break
--             end
--         end
--     end
--
--     if targetscreen ~= nil then
--         local t2 = awful.tag.find_by_name(targetscreen, t.name)
--         if t2 then
--             t:swap(t2)
--         else
--             t.screen = targetscreen
--         end
--         if t.selected then
--             t:view_only()
--         end
--     end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
