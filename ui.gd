extends Control
@onready var currency_label: Label = %CurrencyLabel
@onready var percentage_label: Label = %PercentageLabel
@onready var percentage_bar: TextureProgressBar = %PercentageBar
@onready var use_amount_label: Label = %UseAmountLabel
@onready var yin_yang: TextureRect = %YinYang


const YIN = preload("res://images/Yin.png") #dark
const YANG = preload("res://images/yang.png") #light
const YIN_YANG = preload("res://images/YinYang.png")



func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)
	SignalManager.percentage_changed.connect(update_percentage_label)
	SignalManager.bomb_amount_changed.connect(update_amount)
	SignalManager.yin_yang_changed.connect(update_yin_yang)
	
	custom_minimum_size = Vector2(200, 30) # Width, Height
	percentage_bar.nine_patch_stretch = true
	
	
	update_currency_label()
	update_amount()
	
	
	


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


func update_yin_yang() -> void:
	if GameData.yin and GameData.yang:
		yin_yang.texture = YIN_YANG
		await get_tree().create_timer(1).timeout
		SignalManager.reset_grid.emit()
		GameData.yin_yang = 0
	elif GameData.yang:
		yin_yang.texture = YANG
	else:
		yin_yang.texture = YIN


func update_amount() -> void:
	use_amount_label.text = str(GameData.paint_bombs)


"""func update_currency_label(delta_coins: float = 0) -> void:
	print(GameData.player_currency, "+", delta_coins)
	var currency: int = int(GameData.get("player_currency"))
	if delta_coins == 0:
		currency_label.text = str(currency, " coins")
	elif delta_coins > 0:
		currency_label.text = str(currency, " coins +(", delta_coins, ")")
	elif delta_coins < 0:
		currency_label.text = str(currency, " coins -(", abs(delta_coins), ")")"""


func update_percentage_label(percentage: float) -> void:
	var bar_percentage: float = remap(percentage,GameData.game_over_perc, 1 , 0.0, 1.0)-0.01
	percentage_label.add_theme_color_override("font_color", Color.BLACK)
	percentage_label.text = str(round(bar_percentage * 100), "%  ")
	percentage_bar.value = bar_percentage * 100
	
	var bar_color = Color.GREEN.lerp(Color.RED, 1.0 - bar_percentage)
	percentage_bar.tint_progress = bar_color
