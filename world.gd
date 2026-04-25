extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")
@onready var offset: Node2D = $Offset
const GAME_OVER = preload("res://UI/game_over.tscn")
const MAIN_MENU = preload("res://UI/main_menu.tscn")



func _ready() -> void:
	SignalManager.new_game.connect(new_game)
	var main_menu = MAIN_MENU.instantiate()
	add_child(main_menu)



func new_game() -> void:
	GameData.set_start_square(4, GameData.player_pos)
	
	SignalManager.update_visuals.emit()
	Clock.tick.connect(cycle)
	
	
	var player = PLAYER.instantiate()
	add_child(player)
	

func cycle() -> void:
	var amount: float = GameData.get_player_panels()
	var clean: float = GameData.get_clean_player_panels()
	var corrupted: float = amount - clean
	var percentage_clean: float = float(clean / amount)
	
	if (percentage_clean <= GameData.game_over_perc):
		game_over()
	
	SignalManager.percentage_changed.emit(percentage_clean)
	
	
	money_payout(clean * percentage_clean * 0.005)
	


func game_over() -> void:
	printerr("GAME OVER")
	var game_over  = MAIN_MENU.instantiate()
	add_child(game_over)
	SignalManager.game_over.emit()


func money_payout(increase: float) -> void:
	GameData.player_currency += increase
	SignalManager.currency_changed.emit()



func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("DOWN"):
		move_down()
	if event.is_action_pressed("UP"):
		move_up()
	if event.is_action_pressed("RIGHT"):
		move_right()
	if event.is_action_pressed("LEFT"):
		move_left()

#GameData.change_panel(Vector2i(randi_range(0,16),randi_range(0,7)), randi_range(0,1))

func move_down() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(0,-1), 1):
		GameData.screen_pos.y -= 1
		GameData.player_pos.y -= 1
		offset.global_position.y -= 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	

func move_up() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(0,1), 1):
		GameData.screen_pos.y += 1
		GameData.player_pos.y += 1
		offset.global_position.y += 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()



func move_right() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(1,0), 1):
		GameData.screen_pos.x += 1
		GameData.player_pos.x += 1
		offset.global_position.x -= 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	

func move_left() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(-1,0), 1):
		GameData.screen_pos.x -= 1
		GameData.player_pos.x -= 1
		offset.global_position.x += 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
