extends Node

var player_grid: GridData

var grid_width: int = 17
var grid_height: int = 9

var screen_pos: Vector2i = Vector2i.ZERO
var player_pos: Vector2i = screen_pos + Vector2i(8, 4)

var grid_data: GridData = GridData.new()

func change_panel(grid_pos: Vector2i, state: int) -> void:
	grid_data.change_panel_state(grid_pos, state)
	

func is_visible_on_screen(grid_pos: Vector2i) -> bool:
	return not (abs(GameData.screen_pos.x - grid_pos.x) > 8 or abs(GameData.screen_pos.y - grid_pos.y) > 4)

## USE is_visible_on_screen in advance
func get_screen_pos(grid_pos: Vector2i) -> Vector2i:
	return Vector2i.ZERO

## USE display_pos 
func get_grid_pos(display_pos: Vector2i) -> Vector2i:
	return Vector2i(display_pos.x, display_pos.y) + Vector2i(GameData.screen_pos.x, GameData.screen_pos.y)


func go_to(pos_grid: Vector2i) -> Vector2i:
	return Vector2(pos_grid.x  * 68 + 32, pos_grid.y * 68 + 32)
