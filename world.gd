extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")
@onready var offset: Node2D = $Offset


func _ready() -> void:
	var player = PLAYER.instantiate()
	add_child(player)
	
	"""
	for x in 10:
		GameData.change_panel(Vector2i(randi_range(0,16),randi_range(0,7)), 1)
		
	"""
	GameData.set_start_square(4, GameData.player_pos)
	
	
	SignalManager.update_visuals.emit()
	



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DOWN"):
		move_down()
	if event.is_action_pressed("UP"):
		move_up()
	if event.is_action_pressed("RIGHT"):
		move_right()
	if event.is_action_pressed("LEFT"):
		move_left()

#GameData.change_panel(Vector2i(randi_range(0,16),randi_range(0,7)), randi_range(0,1))

func move_down() -> void:
	GameData.screen_pos.y -= 1
	GameData.player_pos.y -= 1
	offset.global_position.y -= 68
	SignalManager.update_visuals.emit()
	

func move_up() -> void:
	GameData.screen_pos.y += 1
	GameData.player_pos.y += 1
	offset.global_position.y += 68
	SignalManager.update_visuals.emit()



func move_right() -> void:
	GameData.screen_pos.x += 1
	GameData.player_pos.x += 1
	offset.global_position.x -= 68
	SignalManager.update_visuals.emit()
	

func move_left() -> void:
	GameData.screen_pos.x -= 1
	GameData.player_pos.x -= 1
	offset.global_position.x += 68
	SignalManager.update_visuals.emit()
