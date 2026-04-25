extends Sprite2D

var grid_pos: Vector2i




func _ready() -> void:
	Clock.tick.connect(_on_tick)


func despawn() -> void:
	# occupation
	GameData.occupation_data.erase(grid_pos)
	print("Despawned at: ", grid_pos)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick():
	
	try_move(grid_pos + Vector2i(0, 1))
	





func try_move(new_grid_pos: Vector2i) -> void:
	if GameData.request_move(grid_pos, new_grid_pos, 0):
		position = GameData.go_to(new_grid_pos)
		grid_pos = new_grid_pos
