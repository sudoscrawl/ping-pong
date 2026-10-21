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
			ball = -220,
		},
		SpdY = {
			ball = -200,
		},
	},

    predictor = {
        total_trajectory_time = 0,
        collision_to_collision_time = 0,
        final_position = 0
    }
}

return data
