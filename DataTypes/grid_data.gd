extends Resource
class_name GridData

signal grid_updated(grid_data: GridData)

@export var panel_grid: Dictionary

func get_panel_data(x: int, y: int) -> PanelData:
	var panel_data: PanelData = panel_grid[x][y]
	if panel_data:
		return panel_data
	else:
		return null
