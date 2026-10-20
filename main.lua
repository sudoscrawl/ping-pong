local config = require("config")

-- Setting up the main project frame
function love.load()
    local r, g, b = love.math.colorFromBytes(config.palette.background)
    love.graphics.setBackgroundColor(r, g, b)
end 
