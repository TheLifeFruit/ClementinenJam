extends Node

@export var player_grid: GridData

var grid_width: int = 17
var grid_height: int = 9

var player_pos: Vector2i = Vector2i.ZERO

var grid_data = GridData.new()


func change_panel(grid_pos: Vector2i, state: int) -> void:
	grid_data.change_panel_data(grid_pos, state)
	print(grid_pos, ": " ,state)
	

func is_visible_on_screen(grid_pos: Vector2i) -> bool:
	return not (abs(GameData.player_pos.x - grid_pos.x) > 8 or abs(GameData.player_pos.y - grid_pos.y) > 4)

## USE is_visible_on_screen in advance
func get_screen_pos(grid_pos: Vector2i) -> Vector2i:
	return Vector2i.ZERO

## USE display_pos 
func get_grid_pos(display_pos: Vector2i) -> Vector2i:
	return Vector2i.ZERO
