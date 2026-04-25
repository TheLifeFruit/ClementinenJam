extends Sprite2D

var grid_pos: Vector2i
var uuid: String
var type: String

var dir: int = 0
var dirs: Array[Vector2i] = [Vector2i.UP,Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
var rot: Array[float] = [0, PI/2, PI, -PI/2]

func remove() -> void:
	GameData.occupation_data.erase(grid_pos)
	queue_free()

func give_uuid() -> String:
	return uuid


func give_type() -> String:
	return type


func try_move(new_grid_pos: Vector2i) -> void:
	if GameData.request_move(grid_pos, new_grid_pos, 0):
		position = GameData.go_to(new_grid_pos)
		grid_pos = new_grid_pos

## USE 
func turn_by_int(dir: int) -> float:
	if dir > 3 or dir < 0:
		return 0
	else:
		return rot[dir]
