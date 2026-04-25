extends Sprite2D


var grid_pos: Vector2i




func _ready() -> void:
	Clock.tick.connect(_on_tick)






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick():

	#GameData.request_move()
	
	
	#position = GameData.go_to(spawn_point)
	pass
	
