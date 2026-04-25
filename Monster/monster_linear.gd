extends Sprite2D

var direction = 0
var spawn_width = 5
var grid_pos = Vector2i(0,0)
var OUT_X = 0 
var OUT_Y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	OUT_X = get_parent().OUT_X
	OUT_Y = get_parent().OUT_Y

	Clock.tick.connect(_on_tick)
	direction = randi_range(0,3)
	var pos =  randi_range(-spawn_width, spawn_width)
	if direction == 0:
		grid_pos = GameData.player_pos + Vector2i(OUT_X,pos)
	elif direction == 1:
		grid_pos = GameData.player_pos + Vector2i(-OUT_X,pos)
	elif direction == 2:
		grid_pos = GameData.player_pos + Vector2i(pos,OUT_Y)
	else:

		grid_pos = GameData.player_pos + Vector2i(pos,-OUT_Y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick():
	if direction == 0:
		move( Vector2i(-1,0))
	elif direction == 1:
		move( Vector2i(1,0))
	elif direction == 2:
		move( Vector2i(0,-1))
	else:
		move( Vector2i(0,1))
	

	print(grid_pos)
	
	need_delete()
	
	
	
func move(dir:Vector2i):
	var vec: Vector2 = dir
	rotation = vec.angle() - PI/2

	if GameData.request_move(grid_pos,grid_pos+dir, self):

		grid_pos += dir
		GameData.grid_data.change_panel_state(grid_pos,0)
		position = GameData.go_to(grid_pos)	
	else:
		direction = randi_range(0,3)

func need_delete() -> void:
	if abs(grid_pos[0]-GameData.player_pos[0]) > OUT_X*1.5 or abs(grid_pos[1]-GameData.player_pos[1]) > OUT_Y*1.5:
		print("Deleted")
		GameData.occupation_data.erase(grid_pos)
		self.queue_free()
