extends Node2D

const MONSTER_LIN = preload("res://Monster/Monster_linear.tscn")
const MONSTER_JUMPER =  preload("res://Monster/Monster_jumper.tscn")
const MONSTER_PLAYER = preload("res://Monster/Monster_player.tscn")

const LIGHT_BOMB = preload("res://PowerUps/Light_bomb.tscn")
const H_POWERUP = preload("res://PowerUps/BasicLamp.tscn")

const OUT_X = 10
const OUT_Y = 10


func _ready() -> void:
	# Connect to the global tick signal
	Clock.tick.connect(_on_tick)
	Clock.loaded.connect(power_up_spawn)
	
		

func power_up_spawn(entity_inst):
	var grid_pos = GameData.player_grid.keys().pick_random()
	if GameData.grid_data.get_panel_state(grid_pos) == 0:
		#print("Spawnd on black")
		return
	entity_inst.position = GameData.go_to(grid_pos)
	entity_inst.grid_pos = grid_pos
	add_child(entity_inst)
	pass
	
	
func spawn(entity):
	
	var field = GameData.player_field
	var dir = randi_range(0, 3)
	var grid_pos
	# Mapped to match base class dirs: 0: DOWN | 1: RIGHT | 2: DOWN | 3: LEFT
	if dir == 0:
		var pos = randi_range(field[2], field[3])
		grid_pos =Vector2i (pos, field[1])
		grid_pos.y += 4
	
	if dir == 2:
		var pos = randi_range(field[2], field[3])
		grid_pos =Vector2i (pos, field[0])
		grid_pos.y -= 4
		
	if dir == 1:
		var pos = randi_range(field[0], field[1])
		grid_pos =Vector2i (field[2], pos)
		grid_pos.x -= 4
	
	if dir == 3:
		var pos = randi_range(field[0], field[1])
		grid_pos =Vector2i (field[3], pos)
		grid_pos.x += randi_range(1,4)


	
	
	
	entity.dir = dir
	entity.rotation = entity.turn_by_int(dir)
	GameData.occupation_data[grid_pos] = entity
	entity.grid_pos = grid_pos
	entity.position = GameData.go_to(grid_pos)
	add_child(entity)
	entity.visible = true
	
	



func _on_tick() -> void:
	if Clock.current_tick % 10 == 0:
		var entity = MONSTER_PLAYER.instantiate()
		spawn(entity)
		entity = MONSTER_JUMPER.instantiate()
		spawn(entity)
		entity = MONSTER_LIN.instantiate()
		spawn(entity)
		entity = LIGHT_BOMB.instantiate()
		power_up_spawn(entity)
		# Execute logic on specific tick intervals (e.g., every 10 ticks)
		

	
