extends body

var spawn_width: int = 5
var OUT_X: int = 0
var OUT_Y: int = 0

func _ready() -> void:
	super() 
	
	OUT_X = get_parent().OUT_X
	OUT_Y = get_parent().OUT_Y
	Clock.tick.connect(_on_tick)
	
	dir = randi_range(0, 3)
	var pos = randi_range(-spawn_width, spawn_width)
	
	# Mapped to match base class dirs: 0: UP | 1: RIGHT | 2: DOWN | 3: LEFT
	if dir == 0:
		grid_pos = GameData.screen_pos + Vector2i(pos, OUT_Y)
	elif dir == 1:
		grid_pos = GameData.screen_pos + Vector2i(-OUT_X, pos)
	elif dir == 2:
		grid_pos = GameData.screen_pos + Vector2i(pos, -OUT_Y)
	else:
		grid_pos = GameData.screen_pos + Vector2i(OUT_X, pos)

	rotation = turn_by_int(dir)

func _on_tick() -> void:
	if Clock.current_tick % 3 == 0:
		# Multiplies the base direction vector (e.g., Vector2i.UP) by 4
		_custom_move(dirs[dir] * 4)
		
	# 3x3 area effect centered on the entity
	for i in range(-1, 2):
		for j in range(-1, 2):
			var newvec: Vector2i = grid_pos + Vector2i(i, j)
			GameData.grid_data.change_panel_state(newvec, 0)
			
	position = GameData.go_to(grid_pos)
	
	# Cleanup if out of bounds
	if abs(grid_pos.x - GameData.screen_pos.x) > OUT_X * 1.5 or abs(grid_pos.y - GameData.screen_pos.y) > OUT_Y * 1.5:
		remove()

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
