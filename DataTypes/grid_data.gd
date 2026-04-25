extends RefCounted
class_name GridData

signal grid_updated(grid_data: GridData)

@export var panel_grid: Dictionary # Vec2i -> int



func get_panel_state(grid_pos: Vector2i) -> int:
	if not panel_grid.has(grid_pos):
		panel_grid[grid_pos] = 0
		return 0
	
	return panel_grid[grid_pos]
	

func change_panel_state(grid_pos: Vector2i, state: int) -> void:
	if not panel_grid.has(grid_pos):
		panel_grid[grid_pos] = state
		SignalManager.update_panel_visual.emit(grid_pos)
		
		return
