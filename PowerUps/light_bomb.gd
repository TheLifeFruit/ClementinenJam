extends power_up



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SignalManager.player_move.connect(process_modi)
	Clock.tick.connect(check_onit)
	
	
	


func check_onit():
	if GameData.occupation_data.has(grid_pos):
		if not grid_pos == GameData.player_pos:
			self.queue_free()


func process_modi():
	if grid_pos == GameData.player_pos:
		GameData.paint_bombs += 1
		SoundManager.play_powerup_sound1()
		SignalManager.bomb_amount_changed.emit()
		self.queue_free()
