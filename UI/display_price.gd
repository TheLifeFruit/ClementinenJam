extends GridContainer

var kids
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kids = get_children()
	for kid in kids:
		kid.text = ""
	SignalManager.player_move.connect(display_price)
	pass # Replace with function body.

	
func display_price():
	var pos = GameData.player_pos - Vector2i(1,-1)
	for col in range(3):
		for row in range(3):
			var newpos = pos + Vector2i(col,-row)
			if not GameData.player_grid.has(newpos):
				kids[(row * 3) + col].text = str(format_short_number(GameData.get_price(newpos))) + "$"
			else:
				kids[(row * 3) + col].text = ""
		



func format_short_number(value: float) -> String:
	var suffixes: Array[String] = ["", " K", " Mio", " B", " T"]
	var index: int = 0
	
	# Uses 999.5 instead of 1000.0 to prevent rounding up to 4 digits (e.g., "1000 K")
	while value >= 999.5 and index < suffixes.size() - 1:
		value /= 1000.0
		index += 1
		
	var formatted_text: String = ""
	
	# Restrict to exactly 3 numbers based on the scale
	if value >= 100.0 or index == 0:
		formatted_text = "%.0f" % value   # e.g., 221
	elif value >= 10.0:
		formatted_text = "%.1f" % value   # e.g., 23.4
	else:
		formatted_text = "%.2f" % value   # e.g., 2.34
		
	# Swap the metric dot for a comma
	return formatted_text.replace(".", ",") + suffixes[index]
	
