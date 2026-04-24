extends Control

const PANEL = preload("uid://djf3bkxpbavi6")

@onready var grid: GridContainer = $MarginContainer/Grid

var grid_data = GridData.new()



func _ready() -> void:
	grid_data.generate_new_grid(Vector2i(50,50))
	populate_grid(grid_data)
	



func populate_grid(grid_data: GridData) -> void:
	for child in grid.get_children():
		child.queue_free()
	
	for pos in grid_data.panel_grid:
		var panel_data = grid_data.get_panel_data(pos)
		
		if (not panel_data):
			printerr("Invalid Data")
			break
			
		
		var panel = PANEL.instantiate()
		grid.add_child(panel)
		# Subscriptions
		
		
		if panel_data:
			panel.set_panel_data(panel_data)
			panel.show_pos()
