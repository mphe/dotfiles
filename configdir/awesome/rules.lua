local awful = require("awful")
local beautiful = require("beautiful")
local clientconfig = require("client_config")
local utils = require("utils")

-- luacheck: globals mouse

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule. {{{
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientconfig.keys,
            buttons = clientconfig.buttons,
            screen = awful.screen.preferred,
            floating = true,  -- Make all clients floating
            size_hints_honor = true,
            placement = utils.do_placement,
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
                -- "TelegramDesktop",
                "discord",
                "Zathura",
            },
            name = { "Telegram" },
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
            tag = "1",
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
            -- screen = awful.screen.preferred,
            -- placement = awful.placement.centered,
            callback = function(c)
                c.screen = mouse.screen
                end,
        }
    },

    {
        rule_any = { class = { "xpad" } },
        properties = {
            type = "dock",
            tag = "1",
            sticky = true,
            below = true,
            focusable = false,
            keys = {},
            skip_taskbar = true,
        }
    },

    {
        rule = {
            class = "jetbrains-studio",
            name="^win[0-9]+$"
        },
        properties = {
            placement = awful.placement.no_offscreen,
            titlebars_enabled = false
        }
    },

    -- Fix andriod-studio / jetbrains IDEs popup windows disappearing immediately
    -- TODO: could fix unity popups, too
    {
        rule = {
            class = "jetbrains-.*",
            instance = "sun-awt-X11-XWindowPeer",
            name = "win.*",
        },
        properties = {
            floating = true,
            focus = true,
            focusable = false,
            ontop = true,
            placement = awful.placement.restore,
            buttons = {}
        }
    },

    -- Fix Godot Popups being always centered and hide them in taskbar
    {
        rule = {
            instance = "Godot_Engine",
            type = "utility",
        },
        properties = {
            placement = awful.placement.restore,
            buttons = {},
            skip_taskbar = true,
        }
    },

    -- Maximized clients
    {
        rule_any = { class = { "Aseprite", }, },
        properties = { maximized = true, }
    }
}
