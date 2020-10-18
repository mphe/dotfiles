local wibox = require("wibox")

local M = {}

function M.derive(base)
    local Subclass = {}

    function Subclass.allocate(...)
        local o = {}
        setmetatable(o, { __index = Subclass })
        o:create(...)
        return o
    end

    return setmetatable(Subclass, {
        __index = base,
        __call = function(_, ...) return Subclass.allocate(...) end
    })
end


local BaseWidget = M.derive(nil)

function BaseWidget:create(...)
    -- Can be implemented by derived widgets
end

function BaseWidget:update()
    -- Can be implemented by derived widgets
end

-- widget and/or icon can be nil.
function BaseWidget:init(widget, icon, force_size)
    self._container = wibox.layout.fixed.horizontal()
    if icon then
        local imgbox = wibox.widget.imagebox(icon)
        -- imgbox.forced_width = force_size
        -- imgbox.forced_height = force_size
        -- imgbox.resize = true
        self._container:add(imgbox)
    end
    if widget then
        self._container:add(widget)
    end
    return self._container
end

function BaseWidget:set_icon(icon)
    if self._container then
        self._container:get_children()[1].image = icon
    end
end

function BaseWidget:get_container()
    return self._container
end

function BaseWidget.derive()
    return M.derive(BaseWidget)
end

M.BaseWidget = BaseWidget
return M
