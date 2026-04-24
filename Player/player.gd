extends Sprite2D
var x: int = 0

func go_to(pos_grid: Vector2i) -> void:

	global_position = Vector2(pos_grid.x  * 68 + 32, pos_grid.y * 68 + 32)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		
		go_to(Vector2i(x, 0))
		x += 1
