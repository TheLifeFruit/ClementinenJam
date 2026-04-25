extends Node

signal update_visuals()

signal update_panel_visual(grid_pos: Vector2i)


signal rebuild_player_grid()

signal currency_changed()

func _ready() -> void:
	update_visuals.connect(print_state)
	

func print_state() -> void:
	print("screen refresh")
