local data = {
	cords = {
		posY = {
			player = 334,
			opponent = 334,
			ball = 234,
		},
		posX = {
			ball = 400,
		},
	},

	scores = {
		player = 0,
		opponent = 0,
	},

	velocity = {
		SpdX = {
			ball = -450,
		},
		SpdY = {
			ball = -400,
			player = 75,
			opponent = 100,
		},
	},

	predictor = {
		total_trajectory_time = 0,
		collision_to_collision_time = 0,
		remaining_time = 0,
		number_of_collisions = 0,
		final_position = 334,
	},
}
return data
