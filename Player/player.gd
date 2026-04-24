extends Sprite2D
var x: int = 0

func go_to(pos: Vector2i) -> void:
	if pos.x < 0 or pos.y < 0:
		printerr("out of range")
		return
	global_position = Vector2(pos.x  * 68 + 32, pos.y * 68 + 32)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		
		go_to(Vector2i(x, 0))
		x += 1
