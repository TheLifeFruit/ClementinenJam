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
		spawn_point = GameData.player_pos + [OUT_X,pos] 
	elif direction == 1:
		spawn_point = GameData.player_pos + [-OUT_X,pos]
	elif direction == 2:
		spawn_point = GameData.player_pos + [pos,OUT_Y]
	else:
		spawn_point = GameData.player_pos + [pos,-OUT_Y]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick():
	if Clock.current_tick % 3 == 0:
		if direction == 0:
			spawn_point += [-3,0]
		elif direction == 1:
			spawn_point += [3,0]
		elif direction == 2:
			spawn_point += [0,-3]
		else:
			spawn_point += [0,3]
	# 3 auf 3 feld
	
	
	if abs(spawn_point[0]-GameData.player_pos[0]) > OUT_X*1.5 or abs(spawn_point[1]-GameData.player_pos[1]) > OUT_Y*1.5:
		self.queue_free()
	
