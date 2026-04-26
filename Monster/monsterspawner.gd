extends Node2D

const MONSTER_LIN = preload("res://Monster/Monster_linear.tscn")
const MONSTER_JUMPER = preload("uid://deaewn4c23uc7")
const MONSTER_PLAYER = preload("res://Monster/Monster_player.tscn")
const MONSTER_ERASER = preload("res://Monster/monster_eraser.tscn")

const LIGHT_BOMB = preload("res://PowerUps/Light_bomb.tscn")
const LAMP = preload("res://PowerUps/BasicLamp.tscn")

const YIN_YANG = preload("res://PowerUps/YinYang.tscn")


var flag: int = 0



var power_ups: Dictionary = {
	"yin": YIN_YANG,
	"yang": YIN_YANG,
	"lamp": LAMP,
	"light_bomb": LIGHT_BOMB,
}


var mobs: Dictionary = {
	"lin": MONSTER_LIN,
	"laser": MONSTER_PLAYER,
	"eraser": MONSTER_ERASER,
}

var mob_weight: Dictionary = {
	"lin": 5,
	"laser": 1,
	"eraser": 3,
}


var mob_cost: Dictionary = {
	"lin": 1,
	"laser": 9,
	"eraser": 6,
}


const OUT_X = 10
const OUT_Y = 10


func _ready() -> void:
	# Connect to the global tick signal
	Clock.tick.connect(_on_tick)
	Clock.loaded.connect(power_up_spawn)
	for pwer_up in power_ups:
		GameData.power_ups[pwer_up] = 0
	SignalManager.reset_grid.connect(rare_wave)
	

func rare_wave() -> void:
	flag = false
	if randf_range(0, 1) > 0.95:
		flag = true

func power_up_spawn(type: String = "", spawn_panel_state: int = 1, outside: bool = false) -> bool:
	if not power_ups.has(type):
		return false
	
	var grid_pos: Vector2i
	if not outside:
		grid_pos = GameData.player_grid.keys().pick_random()
		var spawned_on_state = GameData.grid_data.get_panel_state(grid_pos)
		if GameData.occupation_data.has(grid_pos):
			return false
		if spawned_on_state != spawn_panel_state:
			return false
	else:
		## TODO Implement
		return true
	
	
	GameData.power_ups[type] += 1
	var entity_inst = power_ups[type].instantiate()
	entity_inst.position = GameData.go_to(grid_pos)
	entity_inst.grid_pos = grid_pos
	if type != "":
		entity_inst.type = type
	add_child(entity_inst)
	return true


func spawn(entity, dir: int = -1):
	if dir > 3 or dir < 0:
		dir = randi_range(0, 3)
	var grid_pos = get_rnd_grid_pos(dir)
	
	spawn_logic(entity, dir, grid_pos)


func get_rnd_grid_pos (dir: int, offset: int = 4) -> Vector2i:
	# Mapped to match base class dirs: 0: DOWN | 1: RIGHT | 2: UP | 3: LEFT
	var field = GameData.player_field
	var grid_pos
	if dir == 0:
		var pos = randi_range(field[2], field[3])
		grid_pos = Vector2i (pos, field[1])
		grid_pos.y += offset
	
	if dir == 2:
		var pos = randi_range(field[2], field[3])
		grid_pos =Vector2i (pos, field[0])
		grid_pos.y -= offset
		
	if dir == 1:
		var pos = randi_range(field[0], field[1])
		grid_pos =Vector2i (field[2], pos)
		grid_pos.x -= offset
	
	if dir == 3:
		var pos = randi_range(field[0], field[1])
		grid_pos =Vector2i (field[3], pos)
		grid_pos.x += offset
	return grid_pos


## Helper
func spawn_logic(entity, dir, grid_pos) -> void:
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
	power_up_spawn("yang", -1, false)

func spawn_eraser() -> void:
	var eraser_node = MONSTER_ERASER.instantiate()
	spawn(eraser_node, -1)

func spawn_mob_by_type(type: String) -> void:
	if not mobs.has(type):
		return
	var mob = mobs[type].instantiate()
	spawn(mob)


func spawn_cluster_1_1() -> void:
	var dir = randi_range(0, 3)
	var grid_pos = get_rnd_grid_pos(dir, 5)
	var offsets
	if dir == 0 or dir == 2:
		offsets = [Vector2i.ZERO, Vector2i(1, 0), Vector2i(-1, 0)]
	else:
		offsets = [Vector2i.ZERO, Vector2i(0, 1), Vector2i(0, -1)]
	
	for offset in offsets:
		var lin_node = MONSTER_LIN.instantiate()
		spawn_logic(lin_node, dir, grid_pos + offset)



func spawn_cluster_1_2() -> void:
	var dir = randi_range(0, 3)
	var grid_pos = get_rnd_grid_pos(dir,7)
	var offsets = [Vector2i.ZERO, Vector2i(1, 1), Vector2i(-1, -1)]
	for offset in offsets:
		var lin_node = MONSTER_LIN.instantiate()
		spawn_logic(lin_node, dir, grid_pos + offset)

func get_random_mob_type() -> String:
	var total_weight: float = 0.0
	for weight in mob_weight.values():
		total_weight += weight
	
	var roll = randf() * total_weight
	var current_sum = 0.0
	
	for mob_type in mob_weight:
		current_sum += mob_weight[mob_type]
		if roll <= current_sum:
			return mob_type
			
	return "" # Fallback


## get mobs
func get_mob_value(x: float) -> float:
	var max_val = 10.0
	var k = 11.5
	return max_val * (x / (x + k))

func _on_tick() -> void:
	if flag:
		
		
		return
	
	
	if Clock.current_tick % 16 == 0:
		var mob_value = get_mob_value(GameData.wave_cycle)
		while (mob_value > 0 ) :
			var type = get_random_mob_type()
			mob_value -= mob_cost[type]
			spawn_mob_by_type(type)
	
	if Clock.current_tick % 60 == 0:
		if not GameData.power_ups["yin"]:
			spawn_yin()
		elif not GameData.power_ups["yang"]:
			spawn_yang()
	if Clock.current_tick % 20 == 0:
		if randf_range(0, 1) > 0.84:
			power_up_spawn("light_bomb")
		
		
