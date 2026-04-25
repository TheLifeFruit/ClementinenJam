extends Sprite2D

var grid_pos = Vector2i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.player_move.connect(process_modi)
	Clock.tick.connect(check_onit)
	
	var len = GameData.player_grid.size()
	var rand = randi_range(0,len)
	grid_pos = GameData.player_grid.keys().pick_random()
	position = GameData.go_to(grid_pos)
	
	


func check_onit():
	if GameData.occupation_data.has(grid_pos):
		if not grid_pos == GameData.player_pos:
			self.queue_free()


func process_modi():
	if grid_pos == GameData.player_pos:
		print("powerUp")
		for i in range(3):
			for j in range(3):
				var change = grid_pos + Vector2i(i-1,j-1)
				GameData.change_panel(change,1)
				
		self.queue_free()
