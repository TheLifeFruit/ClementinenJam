extends PanelContainer
@onready var panel_color: ColorRect = $ColorRect
@onready var label: Label = $PosLabel

@export var panel_data: PanelData = PanelData.new()


func _ready() -> void:
	assert(panel_data)
	
	if panel_data.get_panel_state() == 1:
		panel_color.color = Color.WHITE
	
	show_pos()
	
	

func set_panel_data(new_panel_data: PanelData) -> void:
	panel_data = new_panel_data


func show_pos() -> void:
	var display_text: String = str("(" , panel_data.grid_pos.x , ", ", panel_data.grid_pos.y, ")")
	label.text =  display_text
