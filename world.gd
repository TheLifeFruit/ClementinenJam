extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")

const GAME_OVER = preload("res://UI/game_over.tscn")
const MAIN_MENU = preload("res://UI/main_menu.tscn")
const SPRAY = preload("res://spray.tscn")

@onready var effect_lib: Node2D = %EffectLib
@onready var grid: Node2D = %Grid
@onready var offset: Node2D = $Offset



func _ready() -> void:
	var grid_node = GameData.GRID.instantiate()
	GameData.grid_node = grid_node
	grid.add_child(grid_node)
	
	SignalManager.reset_grid.connect(GameData.reset_player_field)
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
	GameData.wave_cycle += 1
	
	var amount: float = GameData.get_player_panels()
	var clean: float = GameData.get_clean_player_panels()
	var _corrupted: float = amount - clean
	var percentage_clean: float = float(clean / amount)
	
	
	if (percentage_clean <= GameData.game_over_perc):
		game_over()
	
	SignalManager.percentage_changed.emit(percentage_clean)
	
	
	money_payout(clean * percentage_clean * 0.005)
	


func game_over() -> void:
	printerr("GAME OVER")
	var game_over_screen = MAIN_MENU.instantiate()
	add_child(game_over_screen)
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
	if event.is_action_pressed("SPRAY"):
		spray()
		

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
	

func spray() -> void:
	if GameData.paint_bombs > 0:
		GameData.paint_bombs -= 1
		SignalManager.bomb_amount_changed.emit()
		var spray_node = SPRAY.instantiate()
		var angle = GameData.get_mouse_dir()
		spray_node.position = GameData.go_to(GameData.player_pos)
		spray_node.rotation = angle
		effect_lib.add_child(spray_node)
		var hit_array = get_hit_cells(GameData.player_pos, angle, 3, deg_to_rad(60.0))
		for pos in hit_array:
			GameData.change_panel(pos, 1, 1)
			print(pos)
		GameData.change_panel(GameData.player_pos, 1, 0)
		SoundManager.play_refresh_player_grid()




## HELPER for spray
func get_hit_cells(origin: Vector2i, target_angle: float, range_dist: float, spread: float) -> Array[Vector2i]:
	var hit_cells: Array[Vector2i] = []
	
	var min_x = int(origin.x - range_dist)
	var max_x = int(origin.x + range_dist)
	var min_y = int(origin.y - range_dist)
	var max_y = int(origin.y + range_dist)
	
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var cell = Vector2i(x, y)
			var diff = Vector2(cell) - Vector2(origin)

			# Flip Y für den Winkel-Check, damit "oben" im Grid 
			# auch "oben" für den mathematischen Winkel ist
			var check_angle = Vector2(diff.x, -diff.y).angle()

			var angle_diff = abs(angle_difference(target_angle, check_angle))
			
			if angle_diff <= (spread / 2.0):
				hit_cells.append(cell)
					
	return hit_cells



func remove(_wdmg_type: int = 0) -> void:
	print("PLAYER DMG?")

func give_uuid() -> String:
	return "playa"


func give_type() -> String:
	return "player"
