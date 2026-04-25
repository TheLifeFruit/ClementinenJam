extends CanvasLayer


func _on_new_game_pressed() -> void:
	SignalManager.new_game.emit()
	self.queue_free()
