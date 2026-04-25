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
		attempt_player_move(Vector2i(0, -1))
	if event.is_action_pressed("UP"):
		attempt_player_move(Vector2i(0, 1))
	if event.is_action_pressed("RIGHT"):
		attempt_player_move(Vector2i(1, 0))
	if event.is_action_pressed("LEFT"):
		attempt_player_move(Vector2i(-1, 0))

func attempt_player_move(dir: Vector2i) -> void:
	var target_pos: Vector2i = GameData.player_pos + dir

	# 1. Evaluate Target Tile for Occupants (The Push Mechanic)
	if GameData.occupation_data.has(target_pos):
		var occupant = GameData.occupation_data[target_pos]
		if occupant != null:
			print(occupant)
			if occupant.has_method("push"):
				if not occupant.push(dir):
					# The block is stuck against a wall or another object. 
					# Stop player movement.
					return 
			else:
				# Tile is occupied by a non-pushable entity (e.g., enemy)
				return
		else:
			GameData.occupation_data.erase(target_pos)

	# 2. Standard Player Movement (Executes if tile was empty or block was pushed out of the way)
	if GameData.request_move(GameData.player_pos, target_pos, self, 1):
		GameData.screen_pos += dir
		GameData.player_pos += dir
		
		# Consolidates your hardcoded offset logic mathematically
		offset.global_position.x -= dir.x * 68
		offset.global_position.y += dir.y * 68
		
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
		
	# 3. Target tile is not owned. Try to buy it.
	else:
		if GameData.try_to_buy_panel(target_pos):
			GameData.change_panel(target_pos, 1)
			SignalManager.rebuild_player_grid.emit()
			attempt_player_move(dir) # Recursive call to complete the move after purchase
