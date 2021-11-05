---------------------------
-- Default awesome theme --
---------------------------

-- Ignore line too long warnings
-- luacheck: ignore 631

local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local real_dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local menubar = require("menubar")
-- local gtk = require("beautiful.gtk")
-- local naughty = require("naughty")

-- local DPI_SCALE = 0.8
local DPI_SCALE = 1.0

local dpi = function(value, ...)
    return real_dpi(value * DPI_SCALE, ...)
end

local theme = {}
theme.dpi = dpi  -- Expose dpi function for other scripts

function theme.lookup_icon(name, color, custom_subfolder)
    local image = menubar.utils.lookup_icon(name)

    if not image then
        local function try(searchdir)
            for _, subfolder in pairs({ custom_subfolder, "symbolic", "scalable", }) do
                if subfolder then
                    local icondir = string.format("%s/%s/%s", searchdir, theme.icon_theme, subfolder)
                    local fname = string.format("%s/%s-symbolic.svg", icondir, name)
                    if gears.filesystem.is_dir(icondir) then
                        if gears.filesystem.file_readable(fname) then
                            return fname
                        end
                    end
                    print("Error: Icon " .. fname .. " not found")
                end
            end
            return nil
        end

        image = try(string.format("%s/.icons", os.getenv("HOME")))
            or try("/usr/share/icons")
            or try("/usr/share/icons/hicolor")
    end

    if image and color then
        image = gears.color.recolor_image(image, color)
    end

    return image
end

function theme.lookup_icon_colored(name, color, custom_subfolder)
    color = color or theme.fg_normal
    return theme.lookup_icon(name, color, custom_subfolder)
end

local function create_palette(palette, fallback)
    local out = {}
    for k, v in pairs(palette) do
        out[k] = v or fallback[k]
    end
    return out
end

local awesome_palette = {
    red = "#ff0000",
    accent = "#535d6c",
    bg = "#222222"
}

local arc_palette = {
    red = "#cc575d",
    accent = "#5294e2",
    bg = "#2F343F"
}

local palette = create_palette(arc_palette, awesome_palette)


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "oomox-numix_awesome_icons"
-- theme.icon_theme = "Paper"

-- theme.font          = "Sans 7"
theme.font          = "Sans 8"
-- theme.font          = "Open Sans 7"

theme.bg_normal     = "#222222"
-- theme.bg_normal     = "#2F343F"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"
theme.fullscreen_hide_border = true

-- theme.gtk = gtk.get_theme_variables()
-- theme.bg_normal     = theme.gtk.bg_color
-- theme.fg_normal     = theme.gtk.fg_color
--
-- theme.wibar_bg      = theme.gtk.menubar_bg_color
-- theme.wibar_fg      = theme.gtk.menubar_fg_color
--
-- theme.bg_focus      = theme.gtk.selected_bg_color
-- theme.fg_focus      = theme.gtk.selected_fg_color
--
-- theme.bg_urgent     = theme.gtk.error_bg_color
-- theme.fg_urgent     = theme.gtk.error_fg_color
--
-- theme.bg_minimize   = mix(theme.wibar_fg, theme.wibar_bg, 0.3)
-- theme.fg_minimize   = mix(theme.wibar_fg, theme.wibar_bg, 0.9)
--
-- theme.bg_systray    = theme.wibar_bg
--
-- theme.border_normal = theme.gtk.wm_border_unfocused_color
-- theme.border_focus  = theme.gtk.wm_border_focused_color
-- theme.border_marked = theme.gtk.success_color
--
-- theme.border_width  = dpi(theme.gtk.button_border_width or 1)
-- theme.border_radius = theme.gtk.button_border_radius

-- theme.taglist_bg_focus = "#555555"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- old behaviour
-- theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
-- theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- Generate taglist squares:
local taglist_square_size = dpi(8)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- theme.wibar_icon_margin = dpi(6)
theme.wibar_icon_margin = dpi(4)
theme.wibar_height = 20  -- dpi() is not used on purpose, because it is done in rc.lua depending on screen dpi


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_max_width = dpi(455)
-- theme.notification_max_height = dpi(75)
theme.notification_icon_size = dpi(75)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(100)
theme.main_menu_width = dpi(150)

theme.titlebar_size = dpi(25)
theme.titlebar_margin = math.floor(dpi(4))
theme.titlebar_border_size = dpi(2)
-- theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_normal = palette.bg
theme.titlebar_bg_focus = theme.titlebar_bg_normal
-- theme.titlebar_bg_normal = theme.bg_normal .. "CC"

-- Radius from client corner that allows dragging to resize
theme.client_corner_resize_radius = dpi(20)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
local function generate_titlebar_button(name, icon_path, highlight_color)
    highlight_color = highlight_color or palette.accent
    local normal = theme.lookup_icon_colored(icon_path)
    local highlight = theme.lookup_icon_colored(icon_path, highlight_color)

    -- Yes, all this variants are needed, because of awesome's inconsistently available style names
    for _, active in pairs({ "", "_active", "_inactive" }) do
        for _, mode in pairs({ "", "_focus", "_normal" }) do
            theme[string.format("titlebar_%s_button%s%s", name, mode, active)]       = normal
            theme[string.format("titlebar_%s_button%s%s_hover", name, mode, active)] = highlight
            theme[string.format("titlebar_%s_button%s%s_press", name, mode, active)] = highlight
        end
    end
end

-- generate_titlebar_button("close", themes_path.."default/titlebar/close_normal.png", palette.red)
-- generate_titlebar_button("minimize", themes_path.."default/titlebar/minimize_normal.png")
-- generate_titlebar_button("maximized", themes_path.."default/titlebar/maximized_normal_inactive.png")
-- generate_titlebar_button("floating", themes_path.."default/titlebar/floating_normal_inactive.png")
generate_titlebar_button("close", "actions/window-close", palette.red)
generate_titlebar_button("minimize", "actions/window-minimize")
generate_titlebar_button("maximized", "actions/window-maximize")
generate_titlebar_button("floating", "actions/window-pop-out")
generate_titlebar_button("sticky", themes_path.."default/titlebar/sticky_normal_inactive.png")
generate_titlebar_button("ontop", themes_path.."default/titlebar/ontop_normal_inactive.png")

local themedir = os.getenv("HOME") .. "/.config/awesome/themes/custom/"
theme.wallpaper = os.getenv("HOME") .. "/.cache/awesome/wallpaper.png"

local layoutdir = themedir .. "layouts/"
theme.layout_fairh = layoutdir .. "fairhw.png"
theme.layout_fairv = layoutdir .. "fairvw.png"
theme.layout_floating  = layoutdir .. "floatingw.png"
theme.layout_magnifier = layoutdir .. "magnifierw.png"
theme.layout_max = layoutdir .. "maxw.png"
theme.layout_fullscreen = layoutdir .. "fullscreenw.png"
theme.layout_tilebottom = layoutdir .. "tilebottomw.png"
theme.layout_tileleft   = layoutdir .. "tileleftw.png"
theme.layout_tile = layoutdir .. "tilew.png"
theme.layout_tiletop = layoutdir .. "tiletopw.png"
theme.layout_spiral  = layoutdir .. "spiralw.png"
theme.layout_dwindle = layoutdir .. "dwindlew.png"
theme.layout_cornernw = layoutdir .. "cornernw.png"
theme.layout_cornerne = layoutdir .. "cornerne.png"
theme.layout_cornersw = layoutdir .. "cornersw.png"
theme.layout_cornerse = layoutdir .. "cornerse.png"

-- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )

-- theme = theme_assets.recolor_titlebar(theme, theme.fg_normal, "normal")
-- theme = theme_assets.recolor_titlebar(theme, theme.fg_focus, "focus")







-- local themes_path = gears.filesystem.get_themes_dir()

-- inherit default theme
-- local theme = dofile(themes_path.."default/theme.lua")

-- {{{ colors from https://github.com/NicoHood/arc-theme/blob/master/common/openbox/Arc-Dark/openbox-3/themerc
-- theme.bg_normal     = "#2f343f"  -- window.inactive.title.bg.color
-- -- }}}
--
-- -- {{{ colors from https://github.com/NicoHood/arc-theme/blob/master/common/gtk-2.0/gtkrc-dark
-- theme.fg_normal     = "#d3dae3"  -- fg_color
-- theme.tooltip_bg    = "#4B5162"  -- tooltip_bg_color
--
-- -- a little non-arc-way, but I prefer the focused window to be more distinguishable
-- theme.bg_focus      = "#5294e2"  -- selected_bg_color
-- theme.fg_focus      = "#ffffff"  -- selected_fg_color
--
-- theme.bg_minimize   = "#3e4350"  -- insensitive_bg_color
-- theme.fg_minimize   = "#7c818c"  -- insensitive_fg_color
-- -- }}}
--
-- -- {{{ colors from https://github.com/DaveDavenport/rofi-themes/blob/master/Official%20Themes/Arc-Dark.rasi
-- theme.bg_urgent     = "#a54242"  -- selected-urgent-background
-- theme.fg_urgent     = "#f9f9f9"  -- selected-urgent-foreground
-- -- }}}
--
-- --- {{ https://github.com/NicoHood/arc-theme/blob/master/common/gtk-2.0/main.rc
-- theme.tooltip_shape = function(cr, width, height)
--     gears.shape.rounded_rect(cr, width, height, 2)  -- GtkWidget::tooltip-radius
-- end
-- theme.tooltip_opacity = 235  -- GtkWidget::tooltip-alpha
-- theme.tooltip_border_width = 0  -- default-border
-- -- }}}
--
-- -- to match with the rest of colorscheme
-- theme.bg_systray    = theme.bg_normal
-- theme.border_normal = theme.bg_normal
-- theme.border_focus  = theme.bg_focus
-- theme.border_marked = theme.bg_urgent  -- TODO: check when/where is it used
--
-- -- nicer snap borders
-- theme.snap_bg = theme.border_focus
-- theme.snap_shape = gears.shape.rectangle
--
-- -- {{{ https://github.com/NicoHood/arc-theme/blob/master/README.md
-- -- Wallpaper from the Full Preview, https://pixabay.com/photo-869593/
-- theme.wallpaper = themes_path.."arc-dark/background.jpg"
-- -- }}}
--
-- -- Generate Awesome icon:
-- theme.awesome_icon = theme_assets.awesome_icon(
--     theme.menu_height, theme.bg_focus, theme.fg_focus
-- )
--
-- -- Generate taglist squares:
-- -- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_focus
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )
--
-- -- Recolor Layout icons:
-- theme = theme_assets.recolor_layout(theme, theme.fg_normal)
--
-- -- Recolor titlebar icons:
-- -- TODO: find a way to show hovered/pressed state nicely
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_normal, "normal"
-- )
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_normal, "normal", "hover"
-- )
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_normal, "normal", "press"
-- )
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_focus, "focus"
-- )
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_focus, "focus", "hover"
-- )
-- theme = theme_assets.recolor_titlebar(
--     theme, theme.fg_focus, "focus", "press"
-- )

return theme
