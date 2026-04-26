extends Node2D

const DARK_SPLASH = preload("res://Effects/dark_splash.tscn")



"""
----------------------------------------
[START] Effects
----------------------------------------
"""

func _ready() -> void:
	SignalManager.effect_dark_splash.connect(effect_dark_splash)


func effect_dark_splash(spawn_position: Vector2) -> void:
	var node = DARK_SPLASH.instantiate()
	node.position = spawn_position
	add_child(node)
