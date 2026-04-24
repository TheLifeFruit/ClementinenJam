extends PanelContainer
@onready var panel_color: ColorRect = $ColorRect

@export var panel_data: PanelData = PanelData.new()


func _ready() -> void:
	assert(panel_data)
	
	if panel_data.get_panel_state() == 1:
		panel_color.color = Color.WHITE
	

func set_panel_data(new_panel_data: PanelData) -> void:
	panel_data = new_panel_data
