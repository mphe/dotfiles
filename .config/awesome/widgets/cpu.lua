local awful = require("awful")
local utils = require("utils")
local vicious = require("vicious")
local wibox = require("wibox")

local M = {}

local function creator(args)
    local reg = {
        widget = wibox.layout.constraint(wibox.widget.textbox(), "exact", 24, nil),
    }
    reg.widget.widget:set_align("right")
    reg.vicwidget = vicious.register(reg.widget.widget, vicious.widgets.cpu, function(w, args)
        M.args = args
        return args[1] .. "%"
    end, 3)
    vicious.cache(vicious.widgets.cpu)
    return reg
end

function M.update(reg)
    vicious.force({ reg.widget })
end

-- Adds buttons and mouse enter/leave signals
function M.attach(widget, reg)
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() utils.toggle_run_term("htop") end)
    ))

    utils.registerPopupNotify(widget, "CPU", function(w)
        local cpus = {}
        for i=2,#M.args do
            table.insert(cpus, string.format("Core %i:\t%i%%", i - 1, M.args[i]))
        end
        return table.concat(cpus, "\n")
    end)
end

return setmetatable(M, {__call = function(_,...) return creator(...) end})
