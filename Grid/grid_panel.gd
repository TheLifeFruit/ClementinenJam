extends PanelContainer
@onready var panel_color: ColorRect = $ColorRect
@onready var label: Label = $PosLabel

@export var panel_data: PanelData = PanelData.new()



func set_panel_data(new_panel_data: PanelData) -> void:
	panel_data = new_panel_data


func update_visual() -> void:
	show_pos()
	if panel_data.get_panel_state() == 1:
		panel_color.color = Color.WHITE
	


func show_pos() -> void:
	var display_text: String = str("(" , panel_data.grid_pos.x , ", ", panel_data.grid_pos.y, ")")
	label.text = display_text
	if panel_data.get_panel_state() == 1:
		label.add_theme_color_override("font_color", Color.BLACK)
	else:
		label.add_theme_color_override("font_color", Color.WHITE)
