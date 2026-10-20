local config = require("config")

-- Setting up the main project frame
function love.load()
    local r, g, b = love.math.colorFromBytes(config.palette.background)
    love.graphics.setBackgroundColor(r, g, b)

    playerY = 334
    oppX = 334
end


function love.draw()
    -- Setting up the table separator
    r, g, b = love.math.colorFromBytes(config.palette.seperator)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle(
        "fill",
        506,
        0,
        12,
        768
    )

    r, g, b = love.math.colorFromBytes(config.palette.foreground)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle(
        "fill",
        0,
        playerY,
        20,
        100
    )


    love.graphics.rectangle(
        "fill",
        1004,
        oppX,
        20,
        100
    )
end


function love.keypressed(key)
    if (key == "up" or key == "w" or key == "W") and playerY - 50 > 0 then
        playerY = playerY - 50
    elseif (key == "down" or key == "s" or key == "S") and playerY + 50 < 668 then
        playerY = playerY + 50
    end
end

