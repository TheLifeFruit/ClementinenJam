extends PanelContainer
@onready var panel: ColorRect = $ColorRect
@onready var pos_label: Label = $PosLabel
@onready var display_label: Label = $DisplayLabel


var display_pos: Vector2i
var ignore_color: bool = false


func cleansing(delay: float = 0) -> void:
	ignore_color = true
	await get_tree().create_timer(delay).timeout
	
	var color_tween
	
	color_tween = create_tween()
	
	color_tween.tween_property(panel, "color", Color.WHITE, 0.4).set_ease(Tween.EASE_OUT)
	color_tween.timeout.connect()


func tweened() -> void:
	ignore_color = false


func update_visuals(panel_color: Color, grid_pos: Vector2i, text_color: Color = Color.BLACK) -> void:
	if not ignore_color:
		panel.color = panel_color
	elif panel_color.get_luminance() < 0.5:
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
				GameData.change_panel(grid_pos, 1)
				SignalManager.rebuild_player_grid.emit()
			
