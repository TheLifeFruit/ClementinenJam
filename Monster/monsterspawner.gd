extends Node2D

const MONSTER_LIN = preload("res://Monster/Monster_linear.tscn")
const MONSTER_JUMPER = preload("uid://deaewn4c23uc7")
const MONSTER_PLAYER = preload("res://Monster/Monster_player.tscn")

const LIGHT_BOMB = preload("res://PowerUps/Light_bomb.tscn")
const LAMP = preload("res://PowerUps/BasicLamp.tscn")

const YIN_YANG = preload("res://PowerUps/YinYang.tscn")

var power_ups: Dictionary = {
	"yin": YIN_YANG,
	"yang": YIN_YANG,
	"lamp": LAMP,
	"light_bomb": LIGHT_BOMB,
}

const OUT_X = 10
const OUT_Y = 10


func _ready() -> void:
	# Connect to the global tick signal
	Clock.tick.connect(_on_tick)
	Clock.loaded.connect(power_up_spawn)
	for pwer_up in power_ups:
		GameData.power_ups[pwer_up] = 0
	


func power_up_spawn(type: String = "", spawn_panel_state: int = 1, outside: bool = false) -> bool:
	if not power_ups.has(type):
		return false
		
	var grid_pos: Vector2i
	if not outside:
		grid_pos = GameData.player_grid.keys().pick_random()
		var spawned_on_state = GameData.grid_data.get_panel_state(grid_pos)
		if spawned_on_state != spawn_panel_state:
			return false
	else:
		## TODO Implement
		return true
		pass
	return true
	
	
	
	GameData.power_ups[type] += 1
	var entity_inst = power_ups[type].instantiate()
	entity_inst.position = GameData.go_to(grid_pos)
	entity_inst.grid_pos = grid_pos
	if type != "":
		entity_inst.type = type
	add_child(entity_inst)



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
	

	


func spawn_yin() -> void:
	power_up_spawn("yin", 1, false)

func spawn_yang() -> void:
	power_up_spawn("yang", 0, false)

func _on_tick() -> void:
	if Clock.current_tick % 10 == 0:

		var entity = MONSTER_PLAYER.instantiate()
		spawn(entity)
		entity = MONSTER_JUMPER.instantiate()
		spawn(entity)
		entity = MONSTER_LIN.instantiate()
		spawn(entity)
		power_up_spawn("light_bomb")
		# Execute logic on specific tick intervals (e.g., every 10 ticks)

		var monster_lin = MONSTER_LIN.instantiate()
		var moster_jumper = MONSTER_JUMPER.instantiate()
		var moster_player = MONSTER_PLAYER.instantiate()
		add_child(moster_player)
		add_child(monster_lin)
		
		if not GameData.yin:
			spawn_yin()
		else:
			spawn_yang()
		
		if Clock.current_tick % 10 == 0:
			
			power_up_spawn("light_bomb")
			



	
