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
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")
local utils = require("utils")
local cal = require("cal")
local widgets = require("widgets")
local systray = require("systray")
local treetile = require("treetile")
treetile.focusnew = true
local screenshot = require("screenshot")
local globals = require("globals")
-- }}}

-- keep the linter happy regarding awesome globals
-- luacheck: globals mouse awesome client screen tag root



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
local modkey = globals.modkey
local home = os.getenv("HOME")
local configdir = home .. "/.config/awesome"
local scrot_tool = screenshot.screenshot_custom
screenshot.image_dir = "~/Schreibtisch"
-- }}}

-- Init beautiful {{{
-- awful.screen.set_auto_dpi_enabled(true) -- doesn't seem to work
beautiful.init(configdir .. "/themes/custom/theme.lua")

local icons = require("icons")  -- must be initialized after beautiful

-- Screen specific dpi and wibar heights
local wibar_size_per_screen = {}

if screen[2] then
    screen[2].dpi = 102
    wibar_size_per_screen[2] = beautiful.dpi(26, screen[2])
end
-- }}}

local layoutconfig = nil
-- Config file for temporary/frequently changing layouts (untracked by git)
if utils.file_exists(configdir .. "/layoutconfig.lua") then
    layoutconfig = require("layoutconfig")
end

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

local mymainmenu = require("menu")

-- Menubar configuration
menubar.utils.terminal = globals.terminal -- Set the terminal for applications that require it


-- Widgets {{{
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

local mylauncher = awful.widget.launcher({
    image = icons.endeavouros,
    menu = mymainmenu
})

-- Include here because it requires beautiful theme to be initialized
local todo_widget = require("todo")

local separator = wibox.widget.textbox("  ")
local small_separator = wibox.widget.textbox(" ")

local systraywidget = systray()
systraywidget:toggle() -- Hide the systray
local cpuwidget = widgets.cpu({ timeout = 3 })
local memwidget = widgets.mem({ timeout = 3 })
local volwidget = widgets.volume({ timeout = 500 })
local batwidget = widgets.bat({ timeout = 61, battery = "BAT0", ac = "AC", n_perc = {5, 10}, full_notify = "off", notify = "off" })
local tempwidget = widgets.temp({ timeout = 59, tempfile = "/sys/devices/virtual/thermal/thermal_zone6/temp"})
local mpdwidget = widgets.mpd({ timeout = 3, notify = "off" })
local brightwidget = widgets.brightness()
local wiredwidget = widgets.wired({ autohide = true })
local wifiwidget = widgets.wifi({ autohide = false, interface = "wlan0" })
local fswidget = widgets.fs({ blacklist = { "/dev", "/dev/shm", "/run", "/boot/efi", "/run/user/1000", "/sys/fs/cgroup", } })
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
    local wallpaper = beautiful.wallpaper
    if wallpaper and utils.file_exists(wallpaper) then
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
    s.mywibox = awful.wibar({ position = "top", screen = s, height = wibar_size_per_screen[s.index] })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            small_separator,
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
            separator,
            vpnwidget:get_container(),
            wifiwidget:get_container(),
            wiredwidget:get_container(),
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
    awful.client.focus.global_bydirection(dir, nil, true)
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

    awful.key({}, "XF86AudioRaiseVolume", function() volwidget:incVolume() end,
              { description = "raise volume", group = "media" }),

    awful.key({}, "XF86AudioLowerVolume", function() volwidget:decVolume() end,
              { description = "lower volume", group = "media" }),

    awful.key({}, "XF86AudioMute", function() volwidget:toggleMute() end,
              { description = "mute", group = "media" }),

    awful.key({}, "XF86AudioStop", function()
            utils.async("mpc --wait stop", function(_) mpdwidget:update() end)
        end,
        { description = "stop", group = "media" }),

    awful.key({}, "XF86AudioNext", function()
            utils.async("mpc --wait next", function(_) mpdwidget:update() end)
        end,
        { description = "next", group = "media" }),

    awful.key({}, "XF86AudioPrev", function()
            utils.async("mpc --wait prev", function(_) mpdwidget:update() end)
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
    awful.key({ modkey }, "e", function() awful.spawn(globals.filemgr) end,
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

    awful.key({ modkey }, "Return", function() awful.spawn(globals.terminal) end,
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

-- Set keys
root.keys(globalkeys)
-- }}}

-- Apply rules
require("rules")

-- {{{ Signals
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

    -- c.shape = gears.shape.rounded_rect

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
                layout = wibox.layout.fixed.horizontal
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Prevent xpad from minimizing
client.connect_signal("property::minimized", function(c)
    if c.class == "xpad" then
        c.minimized = false
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
-- }}}
