extends Node



var grid_width: int = 17
var grid_height: int = 9

var screen_pos: Vector2i = Vector2i.ZERO
var player_pos: Vector2i = screen_pos + Vector2i(8, 4)

var grid_data: GridData = GridData.new()
var occupation_data: Dictionary = {} # Vec2i -> object
var player_grid: Dictionary = {} # Vec2i -> bool


var inventory: Dictionary = {"Bombe": 0,}

var player_currency: float = 10
var paint_bombs: int = 1000


var game_over_perc: float = 0.3



"""
----------------------------------------
[START] General UTIL
----------------------------------------
"""
func get_mouse_dir() -> float:
	var center = get_viewport().get_visible_rect().size / 2
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction_vector = center - mouse_pos
	var direction_normalized = direction_vector.normalized()
	
	var angle = direction_vector.angle()
	return angle + PI


func generate_uuid_v4() -> String:
	var crypto := Crypto.new()
	var b := crypto.generate_random_bytes(16)
	b[6] = (b[6] & 0x0F) | (4 << 4)
	b[8] = (b[8] & 0x3F) | (2 << 6)
	
	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" %[
		b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7],
		b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15]
	]



"""
----------------------------------------
[START] Player GRID
----------------------------------------
"""


func try_to_buy_panel(grid_pos: Vector2i) -> bool:
	if get_price(grid_pos) > player_currency:
		return false
	
	if player_grid.has(grid_pos) and player_grid[grid_pos]:
		return false
	
	if not has_neighbours(grid_pos):
		return false
	
	pay_price(get_price(grid_pos))
	player_grid[grid_pos] = true
	return true


## Helper for try_to_buy_panel
func has_neighbours(grid_pos: Vector2i) -> bool:
	var dirs = [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]
	
	
	for dir in dirs:
		if player_grid.has(grid_pos + dir):
			return true
	
	
	return false

func set_start_square(l2: int, middle: Vector2i) -> void:
	for x in range(middle.x - l2, middle.x + l2):
		for y in range(middle.y - l2, middle.y + l2):
			grid_data.panel_grid[Vector2i(x,y)] =  1
			player_grid[Vector2i(x,y)] = true
	SignalManager.rebuild_player_grid.emit()
	
	# DISABLED SINCE START ALWAYS REFRESHES
	#SignalManager.update_visuals.emit()


func get_price(grid_pos: Vector2i) -> int:
	return 1


func pay_price(price: int) -> void:
	player_currency -= price
	SignalManager.currency_changed.emit()

## Returns number of player owned panels
func get_player_panels() -> int:
	return player_grid.size()

## Returns number of player corrupted panels
func get_clean_player_panels() -> int:
	var count: int = 0
	for pos in player_grid:
		if grid_data.panel_grid.has(pos) and grid_data.panel_grid[pos] == 1:
			count += 1
	return count


## Returns number of player corrupted panels
func get_corrupted_player_panels() -> int:
	return get_player_panels() - get_clean_player_panels()


"""
----------------------------------------
[START] GRID INTERACTION
----------------------------------------
"""

func change_panel(grid_pos: Vector2i, state: int, dmg: int = 0) -> void:
	if dmg > 0:
		if occupation_data.has(grid_pos):
			occupation_data[grid_pos].remove()
	if (state == 1 and not player_grid.has(grid_pos)):
		return
	grid_data.change_panel_state(grid_pos, state)
	



## Use in combination with powerups
func reset_player_field() -> void:
	for pos in player_grid:
		grid_data.panel_grid[pos] = 1




"""
----------------------------------------
[START] POSITION / MOVEMENT
----------------------------------------
"""


func is_visible_on_screen(grid_pos: Vector2i) -> bool:
	return not (abs(GameData.screen_pos.x - grid_pos.x) > 8 or abs(GameData.screen_pos.y - grid_pos.y) > 4)

## USE is_visible_on_screen in advance
func get_screen_pos(grid_pos: Vector2i) -> Vector2i:
	return grid_pos - screen_pos

## USE display_pos 
func get_grid_pos(display_pos: Vector2i) -> Vector2i:
	return screen_pos + display_pos


## Input current and desired new grid_pos
func request_move(current_pos: Vector2i, desired_grid_pos: Vector2i, node, play_type: int = 0) -> bool:
	# Check occupation
	if occupation_data.has(desired_grid_pos):
		return false
	if play_type == 1 and not player_grid.has(desired_grid_pos):
		return false
	occupation_data.erase(current_pos)
	occupation_data[desired_grid_pos] = node
	
	return true


func get_random_spawn_point() -> Vector2i:
	return Vector2i.ZERO
	

func go_to(pos_grid: Vector2i) -> Vector2i:
	return Vector2(pos_grid.x  * 68 + 32, 648
	-pos_grid.y * 68 -34*2)
