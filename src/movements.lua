local data = require("src.data")

function love.update(dt)
	data.cords.posY.ball = data.cords.posY.ball + (data.velocity.SpdY.ball * dt)
	data.cords.posX.ball = data.cords.posX.ball + (data.velocity.SpdX.ball * dt)

	-- Wall Collisions
	if data.cords.posY.ball <= 0 or data.cords.posY.ball >= 768 then
		data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
	end

	-- Player Collisions
	if data.cords.posY.player <= data.cords.posY.ball and data.cords.posY.ball <= data.cords.posY.player + 100 then
		if data.cords.posX.ball >= 0 and data.cords.posX.ball <= 20 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
		end
	end
end
