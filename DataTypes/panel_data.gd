extends RefCounted
class_name PanelData

@export var grid_pos: Vector2i
@export var state: int = 0



func update_state(new_state: int) -> void:
	state = new_state

func get_panel_state() -> int:
	return state
