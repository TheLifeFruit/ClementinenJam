extends body

var spawn_width: int = 5
var OUT_X: int = 0 
var OUT_Y: int = 0
var total_moves: int = 15

func _ready() -> void:
	super() # Generates UUID from base class
	
	OUT_X = get_parent().OUT_X
	OUT_Y = get_parent().OUT_Y
	Clock.tick.connect(_on_tick)
	
	dir = randi_range(0, 3)
	var pos = randi_range(-spawn_width, spawn_width)
	
	# Mapped to match base class dirs: 0: UP | 1: RIGHT | 2: DOWN | 3: LEFT
	if dir == 0:
		grid_pos = GameData.player_pos + Vector2i(pos, OUT_Y)
	elif dir == 1:
		grid_pos = GameData.player_pos + Vector2i(-OUT_X, pos)
	elif dir == 2:
		grid_pos = GameData.player_pos + Vector2i(pos, -OUT_Y)
	else:
		grid_pos = GameData.player_pos + Vector2i(OUT_X, pos)

	rotation = turn_by_int(dir)

func _on_tick() -> void:
	if Clock.current_tick % 3 == 0:
		#print(grid_pos,GameData.player_pos)
		
		if total_moves >= 0:
			var dif: Vector2i = GameData.player_pos - grid_pos
			
			# Convert the coordinate difference into a base class direction index (0-3)
			if abs(dif.x) > abs(dif.y):
				dir = 1 if dif.x > 0 else 3 # Right (1) or Left (3)
			else:
				dir = 2 if dif.y > 0 else 0 # Down (2) or Up (0)
			
			_custom_move(dirs[dir])
			total_moves -= 1
		else:
			# Random walk phase
			_custom_move(dirs[dir])
			
		need_delete()

func _custom_move(move_vector: Vector2i) -> void:
	rotation = turn_by_int(dir)
	var target_pos: Vector2i = grid_pos + move_vector

	if GameData.request_move(grid_pos, target_pos, self):
		grid_pos = target_pos
		GameData.grid_data.change_panel_state(grid_pos, 0)
		position = GameData.go_to(grid_pos)    
	else:
		# Pick new direction if blocked
		dir = randi_range(0, 3)

func need_delete() -> void:
	if abs(grid_pos.x - GameData.player_pos.x) > OUT_X * 1.5 or abs(grid_pos.y - GameData.player_pos.y) > OUT_Y * 1.5:
		remove()
