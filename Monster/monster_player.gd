extends Sprite2D

var direction = 0
var spawn_width = 5
var spawn_point = []
const OUT_X = Monsterspawner.OUT_X
const OUT_Y = Monsterspawner.OUT_Y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Clock.tick.connect(_on_tick)
	direction = randi_range(0,3)
	var pos =  randi_range(-spawn_width, spawn_width)
	if direction == 0:
		spawn_point = GameData.screen_pos + Vector2i(OUT_X,pos)
	elif direction == 1:
		spawn_point = GameData.screen_pos + Vector2i(-OUT_X,pos)
	elif direction == 2:
		spawn_point = GameData.screen_pos + Vector2i(pos,OUT_Y)
	else:
		spawn_point = GameData.screen_pos + Vector2i(pos,-OUT_Y)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick():
	var dif: Vector2i = GameData.screen_pos-spawn_point
	if abs(dif[0]) > abs(dif[1]):
		spawn_point[0] += sign(dif[0])*1
	else:
		spawn_point[1] += sign(dif[1])*1
	GameData.grid_data.change_panel_state(spawn_point,1)
	global_position = GameData.go_to(spawn_point)
	
	
	
	if abs(spawn_point[0]-GameData.screen_pos[0]) > OUT_X*1.5 or abs(spawn_point[1]-GameData.screen_pos[1]) > OUT_Y*1.5:
		self.queue_free()
	
