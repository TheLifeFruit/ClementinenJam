extends Sprite2D
class_name body

var grid_pos: Vector2i
var uuid: String
var type: String

var dir: int = 0
var dirs: Array[Vector2i] = [Vector2i.UP,Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
var rot: Array[float] = [0, -PI/2, PI, +PI/2]

var OUT_X: int = 0 
var OUT_Y: int = 0

var unload_flag: bool = false


func _ready() -> void:
	OUT_X = get_parent().OUT_X
	OUT_Y = get_parent().OUT_Y
	Clock.tick.connect(_on_tick)
	SignalManager.game_over.connect(remove)
	#uuid = GameData.generate_uuid_v4()
	
	

func remove(dmg_type: int = 0) -> void:
	if type == "object" and dmg_type < 5:
		return
	
	if type == "monster_beam":
		SoundManager.play_gore2()
	else:
		SoundManager.play_gore1()
	
	SignalManager.effect_dark_splash.emit(position)
	
	GameData.occupation_data.erase(grid_pos)
	SignalManager.game_over.disconnect(remove)
	Clock.tick.disconnect(_on_tick)
	queue_free()

func give_uuid() -> String:
	return uuid

func _on_tick():
	pass

func give_type() -> String:
	return type


func try_move(new_grid_pos: Vector2i) -> bool:
	if GameData.request_move(grid_pos, new_grid_pos, self, 0):
		position = GameData.go_to(new_grid_pos)
		grid_pos = new_grid_pos
		return true
	return false

## USE 
func turn_by_int(dir: int) -> float:
	if dir > 3 or dir < 0:
		return 0
	else:
		return rot[dir]
