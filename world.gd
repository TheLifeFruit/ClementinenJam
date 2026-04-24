extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")
@onready var grid_container: PanelContainer = $GRID


func _ready() -> void:
	var player = PLAYER.instantiate()
	add_child(player)
	
	



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DOWN"):
		move_down()


func move_down() -> void:
	grid_container.update_display()
	GameData.change_panel(Vector2i(randi_range(0,16),randi_range(0,7)), randi_range(0,1))
