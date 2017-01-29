local function loader(t, k)
    return rawget(t, k) or require("widgets." .. k)
end

return setmetatable({}, { __index = loader })
