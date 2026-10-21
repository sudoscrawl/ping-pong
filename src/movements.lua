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
	local opponent_speed = 0
	local target_y = data.cords.posY.opponent -- default: stay put

	if data.velocity.SpdX.ball > 0 then
		-- Ball is heading toward opponent: continuously predict and intercept
		calculate_final_position()
		-- Aim to center the paddle on the predicted landing position
		target_y = data.predictor.final_position - 50
		target_y = math.max(0, math.min(668, target_y))
		-- Move faster as the ball gets closer (urgency)
		local urgency = math.max(0, (data.cords.posX.ball - 20) / 984) -- 0 at player side, 1 at opponent side
		opponent_speed = 150 + 200 * urgency -- 150 to 350 px/s
	elseif data.velocity.SpdX.ball < 0 then
		-- Ball is heading away: return toward center to be ready for the next shot
		target_y = 334
		opponent_speed = 100
	end

	local diff = target_y - data.cords.posY.opponent
	if math.abs(diff) > 2 then
		if diff < 0 then
			data.cords.posY.opponent = math.max(target_y, data.cords.posY.opponent - opponent_speed * dt)
		else
			data.cords.posY.opponent = math.min(target_y, data.cords.posY.opponent + opponent_speed * dt)
		end
	end
	-- Clamp opponent paddle to screen bounds
	data.cords.posY.opponent = math.max(0, math.min(668, data.cords.posY.opponent))
end
