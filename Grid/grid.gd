extends Control

const PANEL = preload("res://Grid/panel.tscn")

@onready var grid: GridContainer = $MarginContainer/Grid

var grid_panel_objects: Dictionary = {} # Vec2i -> Object

#TODO SHARE GRID WITH GAMEDATA

func _ready() -> void:
	SignalManager.update_visuals.connect(update_display)
	populate_display_grid()
	
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Ensure the panel expands to take up available space in a container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL


func update_display() -> void:
	for display_pos in grid_panel_objects:
		
		var panel_data = GameData.grid_data.get_panel_data(Vector2i(display_pos.x, display_pos.y) + Vector2i(GameData.player_pos.x, GameData.player_pos.y))
		
		if (not panel_data):
			printerr("Invalid Data")
			break
		
		
		if panel_data.get_panel_state() == 1:
			grid_panel_objects[display_pos].update_visuals(Color.WHITE, Vector2i(display_pos.x, display_pos.y) + Vector2i(GameData.player_pos.x, GameData.player_pos.y) , Color.BLACK)
		else:
			grid_panel_objects[display_pos].update_visuals(Color.BLACK, Vector2i(display_pos.x, display_pos.y) + Vector2i(GameData.player_pos.x, GameData.player_pos.y) , Color.WHITE)
		

func update_panel_visuals(grid_pos: Vector2i) -> void:
	if is_visible_on_screen(grid_pos):
		grid_panel_objects[grid_pos].update_visuals()


func is_visible_on_screen(grid_pos: Vector2i) -> bool:
	return not (abs(GameData.player_pos.x - grid_pos.x) >  8 or abs(GameData.player_pos.y - grid_pos.y) > 4)



func populate_display_grid() -> void:
	for child in grid.get_children():
		child.queue_free()
	
	for y in range(8, -1, -1):
		for x in GameData.grid_width:
			var panel = PANEL.instantiate()
			grid.add_child(panel)
			grid_panel_objects[Vector2i(x,y)] = panel
			panel.display_pos = Vector2i(x,y)
			panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
			# Subscriptions
		
