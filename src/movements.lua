local data = require("src.data")

local function calculate_final_position()
	-- Time for the ball to reach the opponent's side from its current X position
	local travel_time = (1004 - data.cords.posX.ball) / math.abs(data.velocity.SpdX.ball)
	-- Compute the unrestricted final Y (as if there were no walls)
	local final_y = data.cords.posY.ball + (data.velocity.SpdY.ball * travel_time)
	-- Fold into [0, 768] to simulate wall bounces using period = 2 * 768
	local period = 2 * 768
	-- Lua's % always returns a non-negative result when divisor is positive
	local pos_in_period = final_y % period
	if pos_in_period <= 768 then
		data.predictor.final_position = pos_in_period
	else
		data.predictor.final_position = period - pos_in_period
	end
	-- Clamp to valid range
	data.predictor.final_position = math.max(0, math.min(768, data.predictor.final_position))
end

function love.update(dt)
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
			calculate_final_position()
		end
	elseif
		data.cords.posY.player + 50 <= data.cords.posY.ball and data.cords.posY.ball <= data.cords.posY.player + 100
	then
		if data.cords.posX.ball > 0 and data.cords.posX.ball <= 20 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball < 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
			end
			calculate_final_position()
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
			end
		end
	end

	-- Opponent Movement Mechanisms
	if
		not (
			data.predictor.final_position >= data.cords.posY.opponent
			and data.predictor.final_position <= data.cords.posY.opponent + 100
		)
	then
		if data.predictor.final_position < data.cords.posY.opponent then
			data.cords.posY.opponent = math.max(data.predictor.final_position, data.cords.posY.opponent - (350 * dt))
		elseif data.predictor.final_position > data.cords.posY.opponent + 100 then
			data.cords.posY.opponent =
				math.min(data.predictor.final_position, data.cords.posY.opponent + (350 * dt))
		end
	end
	-- Clamp opponent paddle to screen bounds
	data.cords.posY.opponent = math.max(0, math.min(668, data.cords.posY.opponent))
end
