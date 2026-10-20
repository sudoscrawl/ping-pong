local config = require("config")

-- Setting up the main project frame
function love.load()
    local r, g, b = love.math.colorFromBytes(config.palette.background)
    love.graphics.setBackgroundColor(r, g, b)
end


function love.draw()
    r, g, b = love.math.colorFromBytes(config.palette.score)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle(
        "fill",
        506,
        0,
        12,
        768
    )
end
