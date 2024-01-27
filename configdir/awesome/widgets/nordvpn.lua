local awful = require("awful")
local utils = require("utils")
local gears = require("gears")
local wibox = require("wibox")
local BaseWidget = require("widgets.base").BaseWidget
local icons = require("icons")

local NordVPNWidget = BaseWidget.derive()

local TRANSLATE_MAP = {
    ["Status"]             = "status",
    ["Current server"]     = "current_server",
    ["Country"]            = "country",
    ["City"]               = "city",
    ["Your new IP"]        = "ip",
    ["Current technology"] = "tech",
    ["Transfer"]           = "transfer",
    ["Uptime"]             = "uptime",
}

-- timeout: refresh interval
function NordVPNWidget:create(args)
    args = args or {}

    self.status = {}
    local box = self:init(nil, icons.vpn_disconnected)

    -- For some reason, spaces after the unicode symbol are swallowed, so we put the separating space here
    box:insert(2, wibox.widget.textbox(" "))
    box:insert(1, wibox.widget.textbox(" "))

    local menu = awful.menu({
        items = {
            { "Reconnect", function() self:reconnect() end },
        },
    })

    box:buttons(awful.util.table.join(
        awful.button({}, 1, function() self:toggle_connect() end),
        awful.button({}, 3, function() menu:toggle() end)
    ))

    utils.registerPopupNotify(box, "NordVPN", function(w) -- luacheck: ignore
        -- return utils.table_join(self.status, ":\t")
        return table.concat({
            string.format("Status:\t%s", self.status.status),
            string.format("IP:\t\t%s", self.status.ip),
            string.format("Server:\t%s", self.status.current_server),
            string.format("Country:\t%s", self.status.country),
            string.format("City:\t\t%s", self.status.city),
            string.format("Tech:\t%s", self.status.tech),
        }, "\n")
    end)

    self.timer = gears.timer({ timeout = args.timeout or 7 })
    self.timer:connect_signal("timeout", function() self:update() end)
    self.timer:start()

    self:update()
end

function NordVPNWidget:toggle_connect()
    self:update(function()
        local cmd
        if self:is_connected() then
            cmd = "nordvpn disconnect"
        else
            cmd = "nordvpn connect"
        end

        awful.spawn.easy_async(cmd, function() self:update() end)
    end)
end

function NordVPNWidget:reconnect()
    awful.spawn.easy_async_with_shell("nordvpn disconnect && nordvpn connect",
        function() self:update() end)
end

function NordVPNWidget:is_connected()
    return self.status.status == "Connected"
end

function NordVPNWidget:_reset_status()
    for _, v in pairs(TRANSLATE_MAP) do
        self.status[v] = "N/A"
    end
end

function NordVPNWidget:update(after_cb)
    self:_reset_status()
    awful.spawn.with_line_callback("nordvpn status", {
        stdout = function(line)
            -- nordvpn outputs a ascii loading indicator, so we need to filter
            -- everything until the last \r.
            local pattern = "%s*(.+):%s*(.+)%s*$"
            if string.find(line, "\r") then
                pattern = ".*\r" .. pattern
            end

            local k, v = string.match(line, pattern)
            local statuskey = TRANSLATE_MAP[k]

            -- Do null check on statuskey to prevent errors when nordvpn status
            -- returns unforseen info, e.g. "An update is available".
            if statuskey then
                self.status[statuskey] = v
            end
        end,
        output_done = function(reason, code)  -- luacheck: ignore
            if self:is_connected() then
                self:set_icon(icons.vpn)
            else
                self:set_icon(icons.vpn_disconnected)
            end

            if after_cb then
                after_cb()
            end
        end
    })
end

return NordVPNWidget
