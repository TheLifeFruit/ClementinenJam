extends Resource
class_name GridData

signal grid_updated(grid_data: GridData)

@export var panel_grid: Dictionary # Vec2i -> PanelData

func get_panel_data(pos: Vector2i) -> PanelData:
	var panel_data: PanelData = panel_grid[pos]
	if panel_data:
		return panel_data
	else:
		return null




func generate_new_grid(size: Vector2i) -> void:
	for x in size.x:
		for y in size.y:
			var panel_data = PanelData.new()
			panel_data.update_state(randi() % 2)
			panel_grid[Vector2i(x,y)] = panel_data
