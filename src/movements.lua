local data = require("src.data")

local function calculate_final_position()
	data.predictor.total_trajectory_time = 1024 / math.abs(data.velocity.SpdX.ball)
	data.predictor.collision_to_collision_time = 768 / math.abs(data.velocity.SpdY.ball)
	if data.velocity.SpdY.ball > 0 then
		data.predictor.remaining_time = data.predictor.total_trajectory_time
			- ((768 - data.cords.posY.ball) / data.velocity.SpdY.ball)
		data.predictor.number_of_collisions = math.floor(
			data.predictor.remaining_time / data.predictor.collision_to_collision_time
		) + 1
		data.predictor.remaining_time = data.predictor.remaining_time % data.predictor.collision_to_collision_time

		local direction = data.velocity.SpdY.ball * (-1) ^ data.predictor.number_of_collisions

		if direction > 0 then
			data.predictor.final_position = data.predictor.remaining_time * direction
		else
			data.predictor.final_position = 768 - (data.predictor.remaining_time * direction)
		end
	elseif data.velocity.SpdY.ball < 0 then
		data.predictor.remaining_time = data.predictor.total_trajectory_time
			- ((0 - data.cords.posY.ball) / data.velocity.SpdY.ball)
		data.predictor.number_of_collisions = math.floor(
			data.predictor.remaining_time / data.predictor.collision_to_collision_time
		) + 1
		data.predictor.remaining_time = data.predictor.remaining_time % data.predictor.collision_to_collision_time

		local direction = data.velocity.SpdY.ball * (-1) ^ data.predictor.number_of_collisions

		if direction > 0 then
			data.predictor.final_position = data.predictor.remaining_time * direction
		else
			data.predictor.final_position = 768 - (data.predictor.remaining_time * direction)
		end
	end
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
				calculate_final_position()
			end
		end
	elseif
		data.cords.posY.player + 50 <= data.cords.posY.ball and data.cords.posY.ball <= data.cords.posY.player + 100
	then
		if data.cords.posX.ball > 0 and data.cords.posX.ball <= 20 then
			data.velocity.SpdX.ball = data.velocity.SpdX.ball * -1
			if data.velocity.SpdY.ball < 0 then
				data.velocity.SpdY.ball = data.velocity.SpdY.ball * -1
				calculate_final_position()
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
			data.cords.posY.opponent = math.min(data.predictor.final_position, data.cords.posY.opponent - (75 * dt))
		elseif data.predictor.final_position > data.cords.posY.opponent + 100 then
			data.cords.posY.opponent =
				math.min(data.predictor.final_position - 100, data.cords.posY.opponent + (75 * dt))
		end
	end
end
