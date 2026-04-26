extends Node2D

const MONSTER_LIN = preload("res://Monster/Monster_linear.tscn")
const MONSTER_JUMPER =  preload("res://Monster/Monster_jumper.tscn")
const MONSTER_PLAYER = preload("res://Monster/Monster_player.tscn")

const LIGHT_BOMB = preload("res://PowerUps/Light_bomb.tscn")
const LAMP = preload("res://PowerUps/BasicLamp.tscn")

const YIN_YANG = preload("res://PowerUps/YinYang.tscn")



const OUT_X = 10
const OUT_Y = 10


func _ready() -> void:
	# Connect to the global tick signal
	Clock.tick.connect(_on_tick)
	Clock.loaded.connect(power_up_spawn)
	
		

func power_up_spawn(entity, spawn_panel_state: int = 1, type: bool = false, outside: bool = false) -> bool:
	var grid_pos: Vector2i
	if not outside:
		grid_pos = GameData.player_grid.keys().pick_random()
		var spawned_on_state = GameData.grid_data.get_panel_state(grid_pos)
		if spawned_on_state != spawn_panel_state:
			return false
	else:
		## TODO Implement
		pass
	
	
	
	
	
	var entity_inst = entity.instantiate()
	entity_inst.position = GameData.go_to(grid_pos)
	entity_inst.grid_pos = grid_pos
	if type:
		entity_inst.type = true
	add_child(entity_inst)
	return true


func spawn():
	var moster_jumper = MONSTER_JUMPER.instantiate()
	add_child(moster_jumper)
	


func spawn_ying() -> void:
	power_up_spawn(YIN_YANG, 1, false, false)

func spawn_yang() -> void:
	power_up_spawn(YIN_YANG, 0, false, false)

func _on_tick() -> void:

	# Execute logic on specific tick intervals (e.g., every 10 ticks)
	if Clock.current_tick % 10 == 0:
		var monster_lin = MONSTER_LIN.instantiate()
		var moster_jumper = MONSTER_JUMPER.instantiate()
		var moster_player = MONSTER_PLAYER.instantiate()
		add_child(moster_player)
		add_child(monster_lin)
		
		if not GameData.yang:
			spawn_yang()
		else:
			spawn_ying()
		
		if Clock.current_tick % 10 == 0:
			
				
			
			
			power_up_spawn(LIGHT_BOMB)
			

	
