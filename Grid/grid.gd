extends Control

const PANEL = preload("res://Grid/panel.tscn")

@onready var grid: GridContainer = $MarginContainer/Grid

var grid_panel_objects: Dictionary = {} # Vec2i -> Object

var player_gray: Color = Color(0.224, 0.224, 0.224, 1.0)

#TODO SHARE GRID WITH GAMEDATA


func _ready() -> void:
	
	SignalManager.update_visuals.connect(update_display)
	SignalManager.update_panel_visual.connect(update_panel_visuals)
	
	populate_display_grid()
	
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Ensure the panel expands to take up available space in a container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL




func update_display() -> void:
	for display_pos in grid_panel_objects:
		var grid_pos = GameData.get_grid_pos(display_pos)
		var panel_state: int = GameData.grid_data.get_panel_state(grid_pos)
		
		if panel_state == 1:
			grid_panel_objects[display_pos].update_visuals(Color.WHITE, grid_pos , Color.BLACK)
		elif panel_state == -1 or not GameData.player_grid.has(grid_pos):
			grid_panel_objects[display_pos].update_visuals(Color.BLACK, grid_pos , Color.WHITE)
		else: 
			grid_panel_objects[display_pos].update_visuals(player_gray, grid_pos , Color.WHITE)
		


func update_panel_visuals(grid_pos: Vector2i) -> void:
	
	var screen_pos: Vector2i = GameData.get_screen_pos(grid_pos)
	#print(grid_pos, ": ", screen_pos)
	if not grid_panel_objects.has(screen_pos):
		return
	var panel_state = GameData.grid_data.get_panel_state(grid_pos)
	if  panel_state == 1:
		grid_panel_objects[screen_pos].update_visuals(Color.WHITE, Vector2i(screen_pos.x, screen_pos.y) + Vector2i(GameData.screen_pos.x, GameData.screen_pos.y) , Color.BLACK)
	elif panel_state == -1:
		grid_panel_objects[screen_pos].update_visuals(Color.BLACK, Vector2i(screen_pos.x, screen_pos.y) + Vector2i(GameData.screen_pos.x, GameData.screen_pos.y) , Color.WHITE)
	elif GameData.player_grid.has(grid_pos):
		grid_panel_objects[screen_pos].update_visuals(player_gray, Vector2i(screen_pos.x, screen_pos.y) + Vector2i(GameData.screen_pos.x, GameData.screen_pos.y) , Color.WHITE)
	else:
		grid_panel_objects[screen_pos].update_visuals(Color.BLACK, Vector2i(screen_pos.x, screen_pos.y) + Vector2i(GameData.screen_pos.x, GameData.screen_pos.y) , Color.WHITE)



func is_visible_on_screen(grid_pos: Vector2i) -> bool:
	return not (abs(GameData.screen_pos.x - grid_pos.x) >  8 or abs(GameData.screen_pos.y - grid_pos.y) > 4)



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
		
