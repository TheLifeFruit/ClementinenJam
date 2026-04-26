extends Node

signal tick()
signal loaded()
# Configuration
var ticks_per_second : float = 2.0 # Actions happen twice per second

# State
var current_tick : int = 0
var _time_accumulator : float = 0.0
var stop_clock: bool = true


func _ready() -> void:
	SignalManager.game_over.connect(stop)
	SignalManager.new_game.connect(start)

func stop() -> void:
	stop_clock = true

func start() -> void:
	stop_clock = false

func _process(delta: float) -> void:
	if stop_clock:
		return
	
	_time_accumulator += delta
	
	var time_between_ticks = 1.0 / ticks_per_second
	
	# Use a while loop to catch up if a frame takes longer than a tick
	while _time_accumulator >= time_between_ticks:
		_time_accumulator -= time_between_ticks
		_fire_tick()
	
	ticks_per_second =2 + current_tick/ 50

func _fire_tick() -> void:
	current_tick += 1
	tick.emit()

# Allows changing speed dynamically (e.g., fast forward)
func set_tick_rate(new_rate: float) -> void:
	ticks_per_second = new_rate
