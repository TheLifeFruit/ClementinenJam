extends Node

@warning_ignore("unused_signal")
signal update_visuals()

@warning_ignore("unused_signal")
signal update_panel_visual(grid_pos: Vector2i)

@warning_ignore("unused_signal")
signal player_move()

@warning_ignore("unused_signal")
signal rebuild_player_grid()

@warning_ignore("unused_signal")
signal currency_changed(delta_currency: float)

@warning_ignore("unused_signal")
signal percentage_changed(new_percentage: float)


@warning_ignore("unused_signal")
signal effect_dark_splash(spawn_position: Vector2)

@warning_ignore("unused_signal")
signal player_damage()

@warning_ignore("unused_signal")
signal bomb_amount_changed()

@warning_ignore("unused_signal")
signal yin_yang_changed()

@warning_ignore("unused_signal")
signal reset_grid()

@warning_ignore("unused_signal")
signal game_over()

@warning_ignore("unused_signal")
signal new_game()
