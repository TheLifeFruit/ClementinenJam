extends CanvasLayer


func _on_restart_pressed() -> void:
	SignalManager.new_game.emit()
	self.queue_free()
