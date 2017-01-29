local awful = require("awful")
local utils = require("utils")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget

local WiredWidget = BaseWidget.derive()

function WiredWidget:update()
    local connected = utils.read_number("/sys/class/net/" .. self.interface .. "/carrier") == 1

    if connected ~= self.connected then
        self.connected = connected
        self:updateIcon()
    end

    if not connected then
        return
    end

    self.ip = "N/A"
    utils.async_lines("ip addr show " .. self.interface, function(line)
            self.ip  = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or self.ip
        end)
end

function WiredWidget:create(args)
    local args = args or {}

    self.autohide = args.autohide
    self.interface = args.interface or "enp2s0f0"
    self.connected = false
    self.mac = utils.read("/sys/class/net/" .. self.interface .. "/address", "N/A")
    self.ip = "N/A"

    local box = self:init(nil, icons.net_wired_na)
    self:attach(box)
    self:updateIcon()

    self.timer = timer({ timeout = args.timeout or 30 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()
    self:update()
end

function WiredWidget:updateIcon()
    self:get_container():set_visible(true)
    if self.connected then
        self:set_icon(icons.net_wired)
    elseif not self.autohide then
        self:set_icon(icons.net_wired_na)
    else
        self:get_container():set_visible(false)
    end
end

function WiredWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("nmtui") end)
    ))

    utils.registerPopupNotify(box, "Wired network", function(w)
            if self.connected then
                return "IP:\t\t" .. self.ip .. "\nMAC:\t\t" .. self.mac
            else
                return "Disconnected"
            end
        end)
end

return WiredWidget
