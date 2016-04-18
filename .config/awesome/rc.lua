-- Includes {{{
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.remote = require("awful.remote")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local xdg_menu = require("archmenu")
local vain = require("vain")
local alttab = require("alttab")
local cal = require("cal")
local net_widgets = require("net_widgets")
local utils = require("utils")
local widgets = require("widgets")
local icons = require("icons")
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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
shell = "bash"
terminal = "termite"
terminal_cmd = terminal .. " -e "
vain.widgets.terminal = terminal
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal_cmd .. editor
filemgr = "pcmanfm"
configdir = os.getenv("HOME") .. "/.config/awesome"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
    awful.layout.suit.floating,
    vain.layout.browse,
    vain.layout.uselesstile,
    vain.layout.uselesstile.left,
    vain.layout.uselesstile.bottom,
    vain.layout.uselesstile.top,
    vain.layout.uselessfair,
    vain.layout.uselessfair.horizontal,
    vain.layout.termfair,
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    vain.layout.cascade,
    vain.layout.cascadebrowse,
    vain.layout.centerwork,
}

-- Alt Tab config
-- alttab.settings.preview_box_bg = "#222222"
-- alttab.settings.preview_box_border = "#000000"
alttab.settings.client_opacity = true

-- }}}

-- {{{ Beautiful
beautiful.init(configdir .. "/themes/default/theme.lua")

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.centered(beautiful.wallpaper, s)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[3])
end

awful.layout.set(vain.layout.browse, tags[1][9]) -- Steam
awful.layout.set(vain.layout.uselessfair, tags[1][8]) -- Skype
awful.layout.set(vain.layout.browse, tags[1][1])
if screen.count() > 1 then
    awful.layout.set(vain.layout.uselessfair, tags[2][9]) -- Steam
end

-- Config file for temporary/frequently changing layouts (untracked by git)
if utils.file_exists(configdir .. "/layoutconfig.lua") then
    require("layoutconfig")
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", function() run_term("man awesome") end },
   { "edit config", function() run_term(editor .. awesome.conffile) end },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

systemmenu = {
   { "poweroff", "systemctl poweroff" },
   { "reboot", "systemctl reboot" },
   { "suspend", "systemctl suspend" },
   { "hibernate", "systemctl hibernate" },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "applications", xdgmenu },
        { "system", systemmenu },
        { "open terminal", terminal, "/usr/share/icons/gnome/16x16/apps/utilities-terminal.png" },
        { "open file manager", filemgr, "/usr/share/icons/gnome/16x16/apps/system-file-manager.png" },
        { "open browser", "firefox", "/usr/share/icons/hicolor/16x16/apps/firefox.png" },
    },
    theme = { width = 150 },
})
-- }}}

-- widgets {{{
mylauncher = awful.widget.launcher({
    image = icons.arch,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Separator
separator = wibox.widget.textbox()
separator:set_text("  ")

-- Various widgets
volwidget = widgets.create(widgets.widgets.volume, icons.volume)
cpuwidget = widgets.create(widgets.widgets.cpu, icons.cpu)
memwidget = widgets.create(widgets.widgets.mem, icons.mem)
mpdwidget = widgets.create(widgets.widgets.mpd, icons.mpd)
batwidget = widgets.create(widgets.widgets.bat)
tempwidget = widgets.create(widgets.widgets.temp, icons.temp)
brightwidget = widgets.create(widgets.widgets.brightness, icons.brightness)
systray = widgets.create(widgets.widgets.tray)
systray.witype.toggle(systray, false)

-- Wifi widget
wifiwidget = net_widgets.wireless({
    interface="wlp3s0b1",
    timeout=30,
    font="monospace",
    popup_signal=true,
    onclick = terminal_cmd .. "\"bash -c 'ps -e | grep nmtui && pkill nmtui || nmtui'\""
})

-- Wired widget
-- wiredwidget = net_widgets.indicator({
--     interfaces = {"enp2s0f0"},
-- })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
cal.register(mytextclock)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),

    awful.button({}, 2, function(c)
        c:kill()
    end),

    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end),

    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),

    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(systray.container) end
    right_layout:add(separator)

    right_layout:add(mpdwidget.container)
    right_layout:add(separator)

    -- right_layout:add(wiredwidget)
    right_layout:add(wifiwidget)
    -- right_layout:add(separator)

    right_layout:add(brightwidget.container)
    right_layout:add(separator)

    right_layout:add(tempwidget.container)
    right_layout:add(separator)

    right_layout:add(volwidget.container)
    right_layout:add(separator)

    right_layout:add(batwidget.container)
    right_layout:add(separator)

    right_layout:add(memwidget.container)
    right_layout:add(separator)

    right_layout:add(cpuwidget.container)
    right_layout:add(separator)

    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 5, awful.tag.viewnext),
    -- awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
function switch_focus(dir)
    awful.client.focus.global_bydirection(dir)
    if client.focus then client.focus:raise() end
end

-- Global keys {{{
globalkeys = awful.util.table.join(
    -- Alt Tab
    awful.key({ "Mod1", }, "Tab", function() alttab.switch(1, "Alt_L", "Tab", "ISO_Left_Tab") end),
    awful.key({ "Mod1", "Shift" }, "Tab", function() alttab.switch(-1, "Alt_L", "Tab", "ISO_Left_Tab") end),

    -- Screenshot
    awful.key({}, "Print", function() awful.util.spawn("/home/marvin/bin/screenshot.sh") end),

    -- Open file explorer
    awful.key({ modkey }, "e", function() awful.util.spawn(filemgr) end),
    awful.key({ modkey , "Shift" }, "e", function() awful.util.spawn_with_shell("urxvt -e python3 $(which ranger)") end),

    -- Enable brightness control keys
    awful.key({ }, "XF86MonBrightnessDown", function()
        widgets.widgets.brightness.changeBrightness(-5)
        widgets.update(brightwidget)
    end),
    awful.key({ }, "XF86MonBrightnessUp", function()
        widgets.widgets.brightness.changeBrightness(5)
        widgets.update(brightwidget)
    end),

    -- Enable sound control keys
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("mpc toggle") end),
    awful.key({}, "XF86AudioStop", function()
        awful.util.pread("mpc --wait stop")
        widgets.update(mpdwidget)
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.pread("mpc --wait next")
        widgets.update(mpdwidget)
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.pread("mpc --wait prev")
        widgets.update(mpdwidget)
    end),
    awful.key({}, "XF86AudioRaiseVolume", function()
        widgets.widgets.volume.changeVolume("1dB+")
        widgets.update(volwidget)
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
        widgets.widgets.volume.changeVolume("1dB-")
        widgets.update(volwidget)
    end),
    awful.key({}, "XF86AudioMute", function()
        widgets.widgets.volume.toggleMute()
        widgets.update(volwidget)
    end),

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- Client control
    awful.key({ modkey,           }, "j", function() switch_focus("down") end),
    awful.key({ modkey,           }, "k", function() switch_focus("up") end),
    awful.key({ modkey,           }, "h", function() switch_focus("left") end),
    awful.key({ modkey,           }, "l", function() switch_focus("right") end),

    awful.key({ modkey, "Mod1"     }, "l",     function () awful.tag.incmwfact( 0.01 )    end),
    awful.key({ modkey, "Mod1"     }, "h",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ modkey, "Mod1"     }, "j",     function () awful.client.incwfact( 0.05 )    end),
    awful.key({ modkey, "Mod1"     }, "k",     function () awful.client.incwfact(-0.05)    end),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.global_bydirection("down") end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.global_bydirection("up") end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.global_bydirection("left") end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.global_bydirection("right") end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),


    -- Layout manipulation
    awful.key({ modkey, "Mod5" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Mod5" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end),

    awful.key({ modkey, "Control"   }, "k",
        function ()
            awful.tag.incnmaster(1)
            utils.notify({ title = 'Master', text = tostring(awful.tag.getnmaster()), timeout = 1  })
        end),

    awful.key({ modkey, "Control"   }, "j",
        function ()
            awful.tag.incnmaster(-1)
            utils.notify({ title = 'Master', text = tostring(awful.tag.getnmaster()), timeout = 1  })
        end),

    awful.key({ modkey, "Control" }, "h",
        function ()
            awful.tag.incncol(1)
            utils.notify({ title = 'Columns', text = tostring(awful.tag.getncol()), timeout = 1  })
        end),

    awful.key({ modkey, "Control" }, "l",
        function ()
            awful.tag.incncol(-1)
            utils.notify({ title = 'Columns', text = tostring(awful.tag.getncol()), timeout = 1  })
        end),

    awful.key({ modkey,           }, "space",
        function ()
            awful.layout.inc(layouts,  1)
            utils.notify({ title = 'Layout', text = tostring(awful.layout.getname()), timeout = 1  })
        end),

    awful.key({ modkey, "Shift"   }, "space",
        function ()
            awful.layout.inc(layouts, -1)
            utils.notify({ title = 'Layout', text = tostring(awful.layout.getname()), timeout = 1  })
        end),


    -- Standard program
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal_cmd .. "tmux") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Menubar
    awful.key({ modkey }, "p", menubar.show),

    -- Toggle systray visibility
    awful.key({ modkey, "Control" }, "s", function(c) systray.witype.toggle(systray) end)
)
-- }}}

-- Client keys {{{
clientkeys = awful.util.table.join(
    -- Remap close shortcut
    awful.key({ "Mod1" }, "F4", function (c) c:kill() end),
    awful.key({ modkey }, "F4", function (c) c:kill() end),
    awful.key({ modkey }, "c", function (c) c:kill() end),

    -- awful.key({ modkey, "Control" }, "Return", function(c)
    --     -- Find the newest shell child process -> Read its cwd -> pass it to cd -> Run terminal
    --     awful.util.spawn_with_shell("cd \"$(readlink -e /proc/$(pstree -pn " .. math.ceil(c.pid) .. "|sed -zr 's/.*" .. shell .. "\\(([0-9]+)\\).*/\\1/')/cwd)\";" .. terminal)
    -- end),

    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster(c.screen)) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),

    awful.key({ modkey, "Control" }, "space",  function (c)
            awful.client.floating.toggle(c)
            if awful.client.floating.get(c) and not (c.maximized_horizontal or c.maximized_vertical) then
                awful.placement.centered(c, nil)
            end
        end),

    awful.key({ modkey,           }, "n", function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),

    awful.key({ modkey,           }, "m", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
            c:raise()
        end),
    awful.key({ modkey, "Mod1" }, "m", function(c)
            c.maximized_vertical   = not c.maximized_vertical
            c:raise()
        end),
    awful.key({ modkey, "Mod1" }, "n", function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end)
)
-- }}}

-- Tag keys {{{
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- View tag only on all screens.
        awful.key({ modkey , "Mod5" }, "#" .. i + 9, function ()
            for s = 1, screen.count() do
                local tag = awful.tag.gettags(s)[i]
                if tag then
                    awful.tag.viewmore({ tag }, s)
                end
            end
        end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end
-- }}}

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false },
      callback = function(c)
          if awful.client.floating.get(c) and not (c.maximized_horizontal or c.maximized_vertical) then
              awful.placement.centered(c, nil)
          end
      end },

    { rule = { class = "MPlayer" },
      properties = { floating = true } },

    -- Fix youtube fullscreen
    { rule = { class = "Plugin-container" },
      properties = { floating = true } },

    { rule = { class = "SessionManager" },
      properties = { floating = true } },

    -- Force skype windows to be moved to tag 8
    { rule = { class = "Skype" },
      properties = { tag = tags[1][8] }},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus",
    function(c)
        c.border_color = beautiful.border_focus
        -- c:raise()
        -- c.opacity = 1
    end)

client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
        -- c.opacity = 0.95
    end)
-- }}}
