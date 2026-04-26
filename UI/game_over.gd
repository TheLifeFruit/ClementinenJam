extends CanvasLayer

func _ready() -> void:
	$Control/Label.text = Clock.current_tick


func _on_restart_pressed() -> void:
	SignalManager.new_game.emit()
	self.queue_free()
