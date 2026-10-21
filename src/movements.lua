local data = require("src.data")


local function calculate_final_position()
	local totalTime = 1024 / math.abs(data.velocity.SpdX.ball)
	local C2CTime = 768 / math.abs(data.velocity.SpdY.ball)
	local finalPosY = 0
	if data.velocity.SpdY.ball > 0 then
		totalTime = totalTime - ((768 - data.cords.posY.ball) / data.velocity.SpdY.ball)
		totalTime = totalTime % C2CTime
		finalPosY = totalTime * data.velocity.SpdY.ball
	elseif data.velocity.SpdY.ball < 0 then
		totalTime = totalTime - ((0 - data.cords.posY.ball) / data.velocity.SpdY.ball)
		totalTime = totalTime % C2CTime
		finalPosY = totalTime * data.velocity.SpdY.ball
	end
	return finalPosY
end


function love.update(dt)
	local finalPosY = 334

	data.cords.posY.ball = data.cords.posY.ball + (data.velocity.SpdY.ball * dt)
	data.cords.posX.ball = data.cords.posX.ball + (data.velocity.SpdX.ball * dt)

	-- Horizontal Wall Collisions
	if data.cords.posY.ball <= 0 or data.cords.posY.ball >= 768 then
		data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
	end

	-- Player Collisions
	if data.cords.posY.player <= data.cords.posY.ball and data.cords.posY.ball < data.cords.posY.player + 50 then
		if data.cords.posX.ball > 0 and data.cords.posX.ball <= 20 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball > 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
			end
		end
	elseif
		data.cords.posY.player + 50 <= data.cords.posY.ball and data.cords.posY.ball <= data.cords.posY.player + 100
	then
		if data.cords.posX.ball > 0 and data.cords.posX.ball <= 20 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball < 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
			end
		end
	end

	-- Vertical Wall Collisions
	if data.cords.posX.ball <= 0 then
		data.scores.opponent = data.scores.opponent + 1
		data.velocity.SpdX.ball = 0
		data.velocity.SpdY.ball = 0
	elseif data.cords.posX.ball >= 1024 then
		data.scores.player = data.scores.player + 1
		data.velocity.SpdX.ball = 0
		data.velocity.SpdY.ball = 0
	end

	-- Opponent Collisions
	if data.cords.posY.opponent <= data.cords.posY.ball and data.cords.posY.ball < data.cords.posY.opponent + 50 then
		if data.cords.posX.ball < 1024 and data.cords.posX.ball >= 1004 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball > 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
				finalPosY = getFinalPos()
			end
		end
	elseif
		data.cords.posY.opponent + 50 <= data.cords.posY.ball
		and data.cords.posY.ball <= data.cords.posY.opponent + 100
	then
		if data.cords.posX.ball < 1024 and data.cords.posX.ball >= 1004 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball < 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
				finalPosY = getFinalPos()
			end
		end
	end
end


