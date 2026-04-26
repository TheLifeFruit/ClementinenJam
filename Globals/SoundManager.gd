extends Node

var pool_size = 8
var pool: Array[AudioStreamPlayer] = []
var next_player = 0

@export var powerup_sound1: AudioStreamWAV
@export var powerup_sound2: AudioStreamWAV
@export var powerup_sound3: AudioStreamWAV

@export var refresh_player_grid: AudioStreamWAV

@export var gore1: AudioStreamWAV
@export var gore2: AudioStreamWAV




func _ready():
	for i in range(pool_size):
		var p = AudioStreamPlayer.new()
		add_child(p)
		pool.append(p)
		p.bus = &"SFX"



func play_powerup_sound1() -> void:
	play_sfx(powerup_sound1, 0.1)

func play_powerup_sound2() -> void:
	play_sfx(powerup_sound2, 0.1)

func play_powerup_sound3() -> void:
	play_sfx(powerup_sound3, 0.1)

func play_refresh_player_grid() -> void:
	play_sfx(refresh_player_grid, 0.1)

func play_gore1() -> void:
	play_sfx(gore1, 0.1)

func play_gore2() -> void:
	play_sfx(gore2, 0.1)



func play_sfx(stream: AudioStream, pitch_variance: float = 0.0):
	var player = pool[next_player]
	
	player.stream = stream
	player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
	player.play()
	
	next_player = (next_player + 1) % pool_size
