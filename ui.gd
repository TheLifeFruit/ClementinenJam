extends Control
@onready var currency_label: Label = %CurrencyLabel
@onready var percentage_label: Label = %PercentageLabel
@onready var percentage_bar: TextureProgressBar = %PercentageBar

var gradient


func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)
	SignalManager.percentage_changed.connect(update_percentage_label)
	update_currency_label()
	
	custom_minimum_size = Vector2(200, 30) # Width, Height
	percentage_bar.nine_patch_stretch = true
	
	var tex = GradientTexture2D.new()
	tex.width = 64
	tex.height = 50
	
	
	var grad = Gradient.new()
	grad.set_color(0, Color.WHITE) 
	tex.gradient = grad
	
	percentage_bar.texture_progress = tex

func update_currency_label() -> void:
	var currency: float = float(GameData.get("player_currency"))
	# Calls the formatter and appends the " coins" string
	currency_label.text = " " + format_short_number(currency) + "$" + " + " + str(round(GameData.player_increase)) + "$" 

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



func update_percentage_label(percentage: float) -> void:
	var bar_percentage: float = remap(percentage,GameData.game_over_perc, 1 , 0.0, 1.0)-0.01
	percentage_label.add_theme_color_override("font_color", Color.BLACK)
	percentage_label.text = str(round(bar_percentage * 100), "%  ")
	percentage_bar.value = bar_percentage * 100
	
	var bar_color = Color.GREEN.lerp(Color.RED, 1.0 - bar_percentage)
	percentage_bar.tint_progress = bar_color
