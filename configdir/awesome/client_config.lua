local awful = require("awful")
local globals = require("globals")
local utils = require("utils")
local beautiful = require("beautiful")

local modkey = globals.modkey

-- keep the linter happy regarding awesome globals
-- luacheck: globals mouse client

-- Client keys {{{
local clientkeys = awful.util.table.join(
    -- Remap close shortcut
    awful.key({ "Mod1" }, "F4", function(c) c:kill() end, {description = "close", group = "client"}),
    awful.key({ modkey }, "F4", function(c) c:kill() end, {description = "close", group = "client"}),
    -- awful.key({ modkey }, "c",  function(c) c:kill() end),
    -- awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end, {description = "close", group = "client"}),

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
                utils.do_placement(c)
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
    awful.button({ modkey }, 1, function(c)
        c:raise()
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:raise()
        awful.mouse.client.resize(c)
    end))


return {
    keys = clientkeys,
    buttons = clientbuttons
}
