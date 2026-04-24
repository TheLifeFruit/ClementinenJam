extends Node

signal tick

# Configuration
var ticks_per_second : float = 2.0 # Actions happen twice per second

# State
var current_tick : int = 0
var _time_accumulator : float = 0.0

func _process(delta: float) -> void:
	_time_accumulator += delta
	
	var time_between_ticks = 1.0 / ticks_per_second
	
	# Use a while loop to catch up if a frame takes longer than a tick
	while _time_accumulator >= time_between_ticks:
		_time_accumulator -= time_between_ticks
		_fire_tick()

func _fire_tick() -> void:
	current_tick += 1
	tick.emit()

# Allows changing speed dynamically (e.g., fast forward)
func set_tick_rate(new_rate: float) -> void:
	ticks_per_second = new_rate
