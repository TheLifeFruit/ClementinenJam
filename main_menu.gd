extends CanvasLayer
var highscore = 0
func _ready() -> void:
	SignalManager.game_over.connect(display)
func display():
	var score = Clock.current_tick
	if highscore < score:
		highscore = score
	$Control/HBoxContainer/Score.text =str(score)
	$Control/HBoxContainer/Highscore.text = str(highscore)

func _on_new_game_pressed() -> void:
	SignalManager.new_game.emit()
	self.queue_free()
