extends Control

const PANEL = preload("uid://djf3bkxpbavi6")
@onready var grid: GridContainer = $MarginContainer/Grid

func _ready() -> void:
	pass


func populate_grid(grid_data: GridData) -> void:
	for child in grid.get_children():
		child.queue_free()
	
	for panel_data in grid_data.slot_datas:
		var panel = PANEL.instantiate()
		grid.add_child(panel)
		# Subscriptions
		
		
		if panel_data:
			panel.set_panel_data(panel_data)
