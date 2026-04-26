extends body

var spawn_width: int = 5

var total_moves: int = 15
var wait: int = 7
func _ready() -> void:
	super() # Generates UUID from base class
	

	type = "monster_beam"


func _on_tick() -> void:
		await get_tree().create_timer(clock_offset).timeout
		var dif: Vector2i = GameData.player_pos - grid_pos
		if total_moves >= 0:
			
			
			# Convert the coordinate difference into a base class direction index (0-3)
			if abs(dif.x) < abs(dif.y):
				dir = 1 if dif.x > 0 else 3 # Right (1) or Left (3)
			else:
				dir = 2 if dif.y > 0 else 0 # Down (2) or Up (0)
			
			_custom_move(dirs[dir])
			total_moves -= 1
		else:
			if wait%2 == 1:
				if abs(dif.x) > abs(dif.y):
					dir = 1 if dif.x > 0 else 3 # Right (1) or Left (3)
				else:
					dir = 2 if dif.y > 0 else 0
				rotation = rot[dir]
				get_child(0).modulate.a = 1.1-wait/10.0
				get_child(0).visible = true
			elif wait%2 == 0:
				get_child(0).visible = false
				if wait == 0:
					sprint(grid_pos,grid_pos+ 64*dirs[dir])
			
			wait -= 1


func sprint(from_pos: Vector2i, to_pos: Vector2i) -> void:
	
	# 3. Visual Lerp (Tween)

	var target_pixel_pos = Vector2(GameData.go_to(to_pos)) 

	var tween = create_tween()
	get_child(1).emitting = true
	# The float 0.15 is the duration in seconds. Adjust for speed.
	tween.tween_property(self, "position", target_pixel_pos, 0.3)
	await tween.finished
	# Calculate direction and distance of the sprint
	var diff: Vector2i = to_pos - from_pos
	var step_dir: Vector2i = Vector2i(sign(diff.x), sign(diff.y))
	var distance: int = max(abs(diff.x), abs(diff.y))

	# 1. Logic and Destruction Loop
	for i in range(1, distance + 1):
		var current_step: Vector2i = from_pos + (step_dir * i)

		# Turn the panel black
		GameData.grid_data.change_panel_state(current_step, 0)

		# Check if player is hit
		if current_step == GameData.player_pos:
			SignalManager.player_damage.emit() # Triggers your existing death sequence

		# Check for other objects/monsters and destroy them
		if GameData.occupation_data.has(current_step):
			var entity = GameData.occupation_data[current_step]
			if entity != self:
				GameData.occupation_data.erase(current_step)
				# Call inherited remove if applicable, otherwise force free
				if entity != null:
					if entity.has_method("remove"):
						entity.remove()
					else:
						entity.queue_free()

	# 2. Update Logical Position
	GameData.occupation_data.erase(grid_pos)
	grid_pos = to_pos
	remove()

	
	


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
