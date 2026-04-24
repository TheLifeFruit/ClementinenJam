extends Control

const PANEL = preload("uid://djf3bkxpbavi6")

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
	for pos in grid_panel_objects:
		
		var panel_data = GameData.grid_data.get_panel_data(pos)
		
		if (not panel_data):
			printerr("Invalid Data")
			break
		
		
		if panel_data.get_panel_state() == 1:
			grid_panel_objects[pos].update_visuals(Color.WHITE, pos + GameData.player_pos, Color.BLACK)
		else:
			grid_panel_objects[pos].update_visuals(Color.BLACK, pos + GameData.player_pos, Color.WHITE)
		



func populate_display_grid() -> void:
	for child in grid.get_children():
		child.queue_free()
	
	for y in GameData.grid_height:
		for x in GameData.grid_width:
			var panel = PANEL.instantiate()
			grid.add_child(panel)
			grid_panel_objects[Vector2i(x,y)] = panel
			panel.display_pos = Vector2i(x,y)
			panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
			# Subscriptions
		
