extends Sprite2D

var direction = 0
var spawn_width = 5
var spawn_point = Vector2i(0,0)
var OUT_X = 0 
var OUT_Y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OUT_X = 	Monsterspawner.OUT_X
	OUT_Y = Monsterspawner.OUT_Y
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
	if direction == 0:
		spawn_point += Vector2i(-1,0)
	elif direction == 1:
		spawn_point += Vector2i(1,0)
	elif direction == 2:
		spawn_point += Vector2i(0,-1)
	else:
		spawn_point += Vector2i(0,1)
	
	GameData.grid_data.change_panel_state(spawn_point,1)
	position = GameData.go_to(spawn_point)
	if abs(spawn_point[0]-GameData.screen_pos[0]) > OUT_X*1.5 or abs(spawn_point[1]-GameData.screen_pos[1]) > OUT_Y*1.5:
		self.queue_free()
	
