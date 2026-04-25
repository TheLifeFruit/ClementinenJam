extends Node2D
const PLAYER = preload("uid://bpkpo87ntubhe")
@onready var offset: Node2D = $Offset
const GAME_OVER = preload("res://UI/game_over.tscn")
const MAIN_MENU = preload("res://UI/main_menu.tscn")
const SPRAY = preload("res://spray.tscn")
@onready var effect_lib: Node2D = %EffectLib



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
	if event.is_action_pressed("SPRAY"):
		spray()

#GameData.change_panel(Vector2i(randi_range(0,16),randi_range(0,7)), randi_range(0,1))



func spray() -> void:
	if GameData.paint_bombs > 0:
		GameData.paint_bombs -= 1
		var spray = SPRAY.instantiate()
		var angle = GameData.get_mouse_dir()
		spray.position = GameData.go_to(GameData.player_pos)
		spray.rotation = angle
		effect_lib.add_child(spray)
		var hit_array = get_hit_cells(GameData.player_pos, angle, 3, deg_to_rad(60.0))
		for pos in hit_array:
			GameData.change_panel(pos, 1, 1)
			print(pos)
		GameData.change_panel(GameData.player_pos, 1, 0)

func move_down() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(0,-1), self, 1):
		GameData.screen_pos.y -= 1
		GameData.player_pos.y -= 1
		offset.global_position.y -= 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	else:
		if GameData.try_to_buy_panel(GameData.player_pos + Vector2i(0,-1)):
			GameData.change_panel(GameData.player_pos + Vector2i(0,-1), 1)
			SignalManager.rebuild_player_grid.emit()
			move_down()
	

func move_up() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(0,1), self, 1):
		GameData.screen_pos.y += 1
		GameData.player_pos.y += 1
		offset.global_position.y += 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	else:
		if GameData.try_to_buy_panel(GameData.player_pos + Vector2i(0,1)):
			GameData.change_panel(GameData.player_pos + Vector2i(0,1), 1)
			SignalManager.rebuild_player_grid.emit()
			move_up()



func move_right() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(1,0), self, 1):
		GameData.screen_pos.x += 1
		GameData.player_pos.x += 1
		offset.global_position.x -= 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	else:
		if GameData.try_to_buy_panel(GameData.player_pos + Vector2i(1,0)):
			GameData.change_panel(GameData.player_pos + Vector2i(1,0), 1)
			SignalManager.rebuild_player_grid.emit()
			move_right()
	

func move_left() -> void:
	if GameData.request_move(GameData.player_pos, GameData.player_pos + Vector2i(-1,0), self, 1):
		GameData.screen_pos.x -= 1
		GameData.player_pos.x -= 1
		offset.global_position.x += 68
		SignalManager.update_visuals.emit()
		SignalManager.player_move.emit()
	else:
		if GameData.try_to_buy_panel(GameData.player_pos + Vector2i(-1,0)):
			GameData.change_panel(GameData.player_pos + Vector2i(-1,0), 1)
			SignalManager.rebuild_player_grid.emit()
			move_left()




## HELPER for spray
func get_hit_cells(origin: Vector2i, target_angle: float, range_dist: float, spread: float) -> Array[Vector2i]:
	var hit_cells: Array[Vector2i] = []
	var range_sq = range_dist * range_dist
	
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



func remove() -> void:
	print("PLAYER DMG?")
	queue_free()

func give_uuid() -> String:
	return "playa"


func give_type() -> String:
	return "player"
