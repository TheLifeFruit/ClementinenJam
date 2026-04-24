extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")


func _ready() -> void:
	var player = PLAYER.instantiate()
	add_child(player)
	
