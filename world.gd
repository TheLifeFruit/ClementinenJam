extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")


func _ready() -> void:
	var player = PLAYER.instantiate()
	add_child(player)
	



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DOWN"):
		move_down()


func move_down() -> void:
	pass
