extends body

var spawn = false

func _ready() -> void:
	super() 

func _on_tick() -> void:
	await get_tree().create_timer(clock_offset).timeout
	if Clock.current_tick % 4 == 0:
		if spawn == false:
			spawn = true
			return
		# Multiplies the base direction vector (e.g., Vector2i.UP) by 4
		_custom_move(dirs[dir] * 4)
		
	# 3x3 cross area effect centered on the entity's logical position
	for i in range(-1, 2):
		for j in range(-1, 2):
			if abs(i) + abs(j) <= 1:
				var newvec: Vector2i = grid_pos + Vector2i(i, j)
				GameData.grid_data.change_panel_state(newvec, 0)
			
	# CRITICAL FIX: The instant position snap was removed from here.
	# If left here, it would break the smooth tweening every tick.
	
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
		
		# Smooth visual transition (Lerp)
		var target_pixel_pos = Vector2(GameData.go_to(grid_pos)) # Cast to Vector2
		var tween = create_tween()
		
		# The duration is 0.2 seconds. Adjust this to match your tick rate speed.
		tween.tween_property(self, "position", target_pixel_pos, 0.2)
		
	else:
		# Bounce / pick new direction on failure
		dir = randi_range(0, 3)
