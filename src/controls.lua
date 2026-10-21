local data = require("src.data")

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    -- Upward movement controls
    elseif key == "up" or key == "J" or key == "j" or key == "w" or key == "W" then
        if data.cords.posY.player - 50 > 0 then
            data.cords.posY.player = data.cords.posY.player - 50
        end
    -- Downward movement controls
    elseif key == "down" or key == "K" or key == "k" or key == "S" or key == "s" then
        if data.cords.posY.player + 50 < 668 then
            data.cords.posY.player = data.cords.posY.player + 50
        end
    end
end
