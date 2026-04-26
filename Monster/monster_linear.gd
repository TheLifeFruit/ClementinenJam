extends body

func _ready() -> void:
	super()


func _on_tick() -> void:
	await get_tree().create_timer(clock_offset).timeout
	# dirs array inherited from 'body' automatically translates int to Vector2i
	_custom_move(dirs[dir])
	
	need_delete()

func _custom_move(move_vector: Vector2i) -> void:
	# Update rotation if direction changed in a previous failed move
	rotation = turn_by_int(dir)
	
	var target_pos: Vector2i = grid_pos + move_vector

	if GameData.request_move(grid_pos, target_pos, self):
		grid_pos = target_pos
		GameData.grid_data.change_panel_state(grid_pos, 0)
		position = GameData.go_to(grid_pos)    
	else:
		# Bounce / pick new direction on failure
		dir = randi_range(0, 3)


func need_delete() -> void:
	if abs(grid_pos.x - GameData.player_pos.x) > OUT_X * 1.5 or abs(grid_pos.y - GameData.player_pos.y) > OUT_Y * 1.5:
		# Calls inherited remove() function to clear occupation data and free node
		remove()
