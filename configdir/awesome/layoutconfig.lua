local awful = require("awful")
-- local treetile = require("treetile")

-- getting tag properties using awesome-client
-- $ utils = require("utils")
-- $ screen = require("screen")
-- $ utils.debugtable({screen[2].tags[9].master_width_factor})

return function(s)
    if s.index ~= 1 then
        s.tags[9].layout = awful.layout.suit.corner.nw
        s.tags[9].master_width_factor = 0.53
    end
end
