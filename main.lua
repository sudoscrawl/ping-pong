require("src.controls")
require("src.movements")

local palette = require("src.palette")
local data = require("src.data")
-- Setting up the main project frame
function love.load()
	local r, g, b = love.math.colorFromBytes(palette.background)
	love.graphics.setBackgroundColor(r, g, b)
end

function love.draw()
	-- Setting up the table separator
	r, g, b = love.math.colorFromBytes(palette.seperator)
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", 506, 0, 12, 768)

	r, g, b = love.math.colorFromBytes(palette.foreground)
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle("fill", 0, data.cords.posY.player, 20, 100)

	love.graphics.rectangle("fill", 1004, data.cords.posY.opponent, 20, 100)

	love.graphics.circle("fill", data.cords.posX.ball, data.cords.posY.ball, 12)
end
