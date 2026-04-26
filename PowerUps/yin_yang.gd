extends Sprite2D
var grid_pos = Vector2i.ZERO
@export var type: bool

const YANG = preload("res://images/yang.png") # white




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.player_move.connect(process_modi)
	Clock.tick.connect(check_onit)
	
	grid_pos = GameData.player_grid.keys().pick_random()
	position = GameData.go_to(grid_pos)
	
	if type == true:
		texture = YANG #white
	
	


func check_onit():
	if GameData.occupation_data.has(grid_pos):
		if not grid_pos == GameData.player_pos:
			self.queue_free()


func process_modi():
	if grid_pos == GameData.player_pos:
		if type:
			GameData.yin = true
		else:
			GameData.yang = true
		SignalManager.yin_yang_changed.emit()
		SoundManager.play_powerup_sound2()
		self.queue_free()
