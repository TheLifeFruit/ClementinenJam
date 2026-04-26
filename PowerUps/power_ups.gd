extends Sprite2D
class_name power_up

@export var type: String
var grid_pos: Vector2i = Vector2i.ZERO

func _ready() -> void:
	
	position = GameData.go_to(grid_pos)
