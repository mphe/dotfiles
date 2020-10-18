local awful = require("awful")
local utils = require("utils")
local wibox = require("wibox")
local icons = require("icons")
local BaseWidget = require("widgets.base").BaseWidget
local utils = require("utils")

local TODOWidget = BaseWidget.derive()

function TODOWidget:create(args)
    self.args = args or {}
    self.args.fname = self.args.fname or os.getenv("HOME") .. "/todo.txt"
    self.args.editor = self.args.editor or os.getenv("EDITOR") or "vim"

    local box = self:init(nil, self.args.icon or icons.cpu)
    self:attach(box)
end

function TODOWidget:attach(box)
    box:buttons(awful.util.table.join(
        awful.button({}, 1, function()
                utils.toggle_run_term(self.args.editor .. " " .. self.args.fname)
            end)
    ))
end

return TODOWidget
