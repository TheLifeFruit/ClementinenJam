extends Node2D

const MONSTER_LIN = preload("res://Monster/Monster_linear.tscn")
const MONSTER_JUMPER =  preload("res://Monster/Monster_jumper.tscn")
const MONSTER_PLAYER = preload("res://Monster/Monster_player.tscn")

const LIGHT_BOMB = preload("res://PowerUps/Light_bomb.tscn")

const OUT_X = 10
const OUT_Y = 10


func _ready() -> void:
	# Connect to the global tick signal
	Clock.tick.connect(_on_tick)
	Clock.loaded.connect(power_up_spawn)
	var monster_lin = MONSTER_LIN.instantiate()
	add_child(monster_lin)
	
		

func power_up_spawn():
	pass
func spawn():
	var moster_jumper = MONSTER_JUMPER.instantiate()
	#add_child(moster_jumper)
	

func _on_tick() -> void:
	
	# Execute logic on specific tick intervals (e.g., every 10 ticks)
	if Clock.current_tick % 10 == 0:
		var monster_lin = MONSTER_LIN.instantiate()
		var moster_jumper = MONSTER_JUMPER.instantiate()
		var moster_player = MONSTER_PLAYER.instantiate()
		var light_bomb = LIGHT_BOMB.instantiate()
		add_child(light_bomb)
		add_child(moster_jumper)
		add_child(monster_lin)

	
	
