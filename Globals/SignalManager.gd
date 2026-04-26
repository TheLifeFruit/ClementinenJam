extends Node

signal update_visuals()

signal update_panel_visual(grid_pos: Vector2i)

signal player_move()

signal rebuild_player_grid()

signal currency_changed(delta_currency: float)

signal percentage_changed(new_percentage: float)

signal bomb_amount_changed()

signal game_over()

signal new_game()
