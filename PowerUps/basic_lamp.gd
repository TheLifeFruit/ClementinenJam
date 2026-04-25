extends Sprite2D


var grid_pos: Vector2i

func _ready() -> void:
	Clock.tick.connect(lighting)
	# Assuming you set the initial grid_pos when spawning the object
	position = GameData.go_to(grid_pos)
	GameData.occupation_data[grid_pos] = self

## Called by the player script when walking into this object
func push(dir: Vector2i) -> bool:
	var target_pos: Vector2i = grid_pos + dir
	
	# Attempt to move the block. 
	# Using play_type 1 ensures the block can only be pushed onto owned panels.
	if GameData.request_move(grid_pos, target_pos, self, 1):
		grid_pos = target_pos
		position = GameData.go_to(grid_pos) 
		
		# Block successfully moved
		return true 
		
	# Block hit a wall, edge, or another entity and cannot move
	return false
func lighting():
	var size_dir = [[0,0],[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1]]
	if Clock.current_tick % 3 == 0:
		for vec in size_dir:
			var vec2: Vector2i = Vector2i.ZERO
			vec2.x = vec[0]
			vec2.y = vec[1]
			if GameData.grid_data.get_panel_state(grid_pos + vec2) == 0:
				GameData.change_panel(grid_pos + vec2,1)
				return
		
	
