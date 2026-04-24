extends Resource
class_name GridData

signal grid_updated(grid_data: GridData)

@export var panel_grid: Dictionary # Vec2i -> PanelData

func get_panel_data(grid_pos: Vector2i) -> PanelData:
	if not panel_grid.has(grid_pos):
		var panel_data = PanelData.new()
		panel_data.grid_pos = grid_pos
		panel_grid[grid_pos] = panel_data
		return panel_data
	
	var panel_data: PanelData = panel_grid[grid_pos]
	if panel_data:
		return panel_data
	else:
		return null
	

func change_panel_data(grid_pos: Vector2i, state: int) -> void:
	if not panel_grid.has(grid_pos):
		var panel_data = PanelData.new()
		panel_data.grid_pos = grid_pos
		panel_data.state = state
		panel_grid[grid_pos] = panel_data
		SignalManager.update_panel_visual.emit(grid_pos)
		
		return
	
	panel_grid[grid_pos].update_state(state)
	SignalManager.update_visuals.emit()
	
