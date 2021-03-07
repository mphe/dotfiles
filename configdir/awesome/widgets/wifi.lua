local awful = require("awful")
local gears = require("gears")
local utils = require("utils")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget
local wibox = require("wibox")

local WifiWidget = BaseWidget.derive()

function WifiWidget:create(args)
    args = args or {}

    self.autohide = args.autohide
    self.interface = args.interface or "wlan0"
    self.connected = false
    self.mac = utils.read("/sys/class/net/" .. self.interface .. "/address", "N/A")
    self.ip = "N/A"
    self.ssid = "N/A"
    self.bitrate = "N/A"
    self.level = 0

    local box = self:init(nil, icons.wifi_na)
    self:attach(box)

    self.timer = gears.timer({ timeout = args.timeout or 30 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()
    self:update()
end

function WifiWidget:update()
    self.connected = utils.read_number("/sys/class/net/" .. self.interface .. "/carrier") == 1

    if not self.connected then
        self:updateIcon()
        return
    end

    self.ip = "N/A"
    self.ssid = "N/A"
    self.bitrate = "N/A"
    self.level = 0

    utils.async_lines("ip addr show " .. self.interface, function(line)
            self.ip  = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or self.ip
        end)

    awful.spawn.with_line_callback("iwconfig " .. self.interface, {
        stdout = function(line)
            self.ssid = string.match(line, "ESSID:\"(.+)\"") or self.ssid
            self.bitrate = string.match(line, "Bit Rate=(.+/s)") or self.bitrate
            self.level = tonumber(string.match(line, "Link Quality=(.+)/70")) or self.level
        end,
        output_done = function()
            self.level = math.floor(self.level / 70 * 100)
            self:updateIcon()
        end
    })
end

function WifiWidget:updateIcon()
    self:get_container():set_visible(true)
    if self.connected then
        if self.level < 25 then
            self:set_icon(icons.wifi[1])
        elseif self.level < 50 then
            self:set_icon(icons.wifi[2])
        elseif self.level < 75 then
            self:set_icon(icons.wifi[3])
        else
            self:set_icon(icons.wifi[4])
        end
    elseif not self.autohide then
        self:set_icon(icons.wifi_na)
    else
        self:get_container():set_visible(false)
    end
end

function WifiWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("nmtui") end)
    ))

    utils.registerPopupNotify(box, "WiFi", function(w)
            if self.connected then
                return string.format("IP:     \t%s\nMAC:   \t%s\nSSID:\t%s\nBitrate:\t%s\nLevel:\t%i%%",
                    self.ip, self.mac, self.ssid, self.bitrate, self.level)
            else
                return "Disconnected"
            end
        end)
end

return WifiWidget
