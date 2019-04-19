local awful = require("awful")
local wibox = require("wibox")
local utils = require("utils")
local icons = require("icons")
local lain = require("lain")
local naughty      = require("naughty")
local BaseWidget = require("widgets.base").BaseWidget


local FSWidget = BaseWidget.derive()

function FSWidget:create(args)
    args = args or {}
    args.followtag           = args.followtag or true
    args.notification_preset = args.notification_preset or naughty.config.defaults
    args.partition           = args.partition or "/"
    args.showpopup           = "off"
    args.settings            = function()
        self.data = fs_now
        widget:set_markup(fs_now.used .. "%")
    end

    self.lainwidget = lain.widgets.fs(args)
    local box = self:init(self.lainwidget.widget, args.icon or icons.fs)

    utils.registerPopupNotify(box, "Filesystem", function(w)
        if self.data then
            return string.format("Free:\t\t%.2f GB\nUsed:\t%.2f GB\nSize:\t\t%.2f GB",
                self.data.available_gb,
                self.data.used_gb,
                self.data.size_gb)
        else
            return ""
        end
    end)
end

function FSWidget:update()
    self.lainwidget.update()
end

return FSWidget


-- function FSWidget:create(args)
--     local args = args or {}
--
--     self.widget = wibox.widget.textbox()
--     self.partition = args.partition or nil
--     self.notify = args.notify or true
--
--     local box = self:init(self.widget, args.icon or icons.fs)
--     self:attach(box)
--
--     self.timer = timer({ timeout = args.timeout or 180 })
--     self.timer:connect_signal("timeout", function() self:update() end)
--     self.timer:start()
--     self:update()
-- end
--
-- function FSWidget:update()
--     fs_info, fs_now  = {}, {}
--     utils.async_lines("df -k --output=target,size,used,avail,pcent", function(line)
--         local m,s,u,a,p = string.match(line, "(/.-%s).-(%d+).-(%d+).-(%d+).-([%d]+)%%")
--         m = m:gsub(" ", "") -- clean target from any whitespace
--
--         fs_info[m .. " size_mb"]  = string.format("%.1f", tonumber(s) / fs.unit["mb"])
--         fs_info[m .. " size_gb"]  = string.format("%.1f", tonumber(s) / fs.unit["gb"])
--         fs_info[m .. " used_mb"]  = string.format("%.1f", tonumber(u) / fs.unit["mb"])
--         fs_info[m .. " used_gb"]  = string.format("%.1f", tonumber(u) / fs.unit["gb"])
--         fs_info[m .. " used_p"]   = p
--         fs_info[m .. " avail_mb"] = string.format("%.1f", tonumber(a) / fs.unit["mb"])
--         fs_info[m .. " avail_gb"] = string.format("%.1f", tonumber(a) / fs.unit["gb"])
--         fs_info[m .. " avail_p"]  = string.format("%d", 100 - tonumber(p))
--     end)
--
--     fs_now.size_mb      = fs_info[partition .. " size_mb"]  or "N/A"
--     fs_now.size_gb      = fs_info[partition .. " size_gb"]  or "N/A"
--     fs_now.used         = fs_info[partition .. " used_p"]   or "N/A"
--     fs_now.used_mb      = fs_info[partition .. " used_mb"]  or "N/A"
--     fs_now.used_gb      = fs_info[partition .. " used_gb"]  or "N/A"
--     fs_now.available    = fs_info[partition .. " avail_p"]  or "N/A"
--     fs_now.available_mb = fs_info[partition .. " avail_mb"] or "N/A"
--     fs_now.available_gb = fs_info[partition .. " avail_gb"] or "N/A"
--
--     if notify and tonumber(fs_now.used) >= 99 then
--         naughty.notify({
--             title   = "Warning",
--             text    = partition .. " is full!",
--             timeout = 0,
--             fg      = "#000000",
--             bg      = "#FFFFFF"
--         })
--         -- TODO: mark as notified
--     else
--         -- TODO: unmark as notified
--     end
--
--     utils.debugtable(fs_now or {})
--     utils.debugtable(fs_now["/"] or {})
--     self.widget:set_text(tostring(fs_now.used) .. "%")
--
-- end
--
-- function FSWidget:attach(box)
--     -- box:buttons(awful.util.table.join(
--     --     awful.button({}, 4, function()
--     --         self:incBrightness(5)
--     --     end),
--     --     awful.button({}, 5, function()
--     --         self:incBrightness(-5)
--     --     end)
--     -- ))
--
--     -- utils.registerPopupNotify(box, "Filesystem", function(w)
--     --         utils.debugtable(self.data["/"] or {})
--     --         return string.format("Space remaining:\t%s", self.data["/"].free)
--     --     end)
-- end
--
-- return FSWidget
