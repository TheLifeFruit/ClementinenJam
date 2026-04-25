extends body

var spawn_width: int = 5


func _ready() -> void:
	super() # Calls body._ready() to generate the UUID
	
	
	dir = randi_range(0, 3)
	var pos = randi_range(-spawn_width, spawn_width)
	
	
	# Mapped spawn positions to align with the base class 'dirs' array:
	# 0: UP    | 1: RIGHT | 2: DOWN  | 3: LEFT
	if dir == 0:
		grid_pos = GameData.player_pos + Vector2i(pos, OUT_Y)
	elif dir == 1:
		grid_pos = GameData.player_pos + Vector2i(-OUT_X, pos)
	elif dir == 2:
		grid_pos = GameData.player_pos + Vector2i(pos, -OUT_Y)
	else:
		grid_pos = GameData.player_pos + Vector2i(OUT_X, pos)

	# Initialize visual rotation based on spawn direction
	rotation = turn_by_int(dir)

func _on_tick() -> void:
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
