extends PanelContainer
@onready var panel: ColorRect = $ColorRect
@onready var pos_label: Label = $PosLabel
@onready var display_label: Label = $DisplayLabel


var display_pos: Vector2i



func update_visuals(panel_color: Color, grid_pos: Vector2i, text_color: Color = Color.BLACK) -> void:
	panel.color = panel_color
	
	var display_text: String = str("(" , display_pos.x , ", ", display_pos.y, ")")
	display_label.text = display_text
	display_label.add_theme_color_override("font_color", text_color)
	
	var pos_text: String = str("(" , grid_pos.x , ", ", grid_pos.y, ")")
	pos_label.text = pos_text
	pos_label.add_theme_color_override("font_color", text_color)


func _on_gui_input(event: InputEvent) -> void:
	if (event  is InputEventMouseButton):
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var grid_pos: Vector2i = GameData.get_grid_pos(display_pos)
			print("buying: ", grid_pos, " on display_pos: ", display_pos)
			if GameData.try_to_buy_panel(grid_pos):
				SignalManager.rebuild_player_grid.emit()
			
