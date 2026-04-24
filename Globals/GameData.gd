extends Node

@export var player_grid: GridData

var grid_width: int = 17
var grid_height: int = 9

var player_pos: Vector2i = Vector2i.ZERO

var grid_data = GridData.new()

func change_panel(grid_pos: Vector2i, state: int) -> void:
	grid_data.change_panel_data(grid_pos, state)

func canghe_panel(grid_pos: Vector2i, state: int) -> void:
	grid_data.change_panel_data(grid_pos, state)
	
func go_to(pos_grid: Vector2i) -> Vector2i:

	return Vector2(pos_grid.x  * 68 + 32, pos_grid.y * 68 + 32)
