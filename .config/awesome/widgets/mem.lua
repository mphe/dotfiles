local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")

local M = {}

local function creator(args)
    local reg = {
        widget = wibox.widget.textbox()
    }
    reg.vicwidget = vicious.register(reg.widget, vicious.widgets.mem, function(w, args)
            M.args = args
            return args[1] .. "%"
        end, 3)
    vicious.cache(vicious.widgets.mem)
    return reg
end

function M.update(reg)
    vicious.force({ reg.widget })
end

function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("htop") end)
    ))

    utils.registerPopupNotify(widget, "Memory", function(w)
        return string.format("Memory usage:\t%i / %i MB\nFree memory:\t%i MB\nSwap usage:\t%i / %i MB (%i%%)\nFree swap:\t%i MB",
            M.args[2], M.args[3], M.args[4], M.args[6], M.args[7], M.args[5], M.args[8])
    end)
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
