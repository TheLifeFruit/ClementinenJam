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
	update_yin_yang()
	
	

func update_yin_yang() -> void:
	if GameData.yin and GameData.yang:
		yin_yang.texture = YIN_YANG
		await get_tree().create_timer(1).timeout
		SignalManager.reset_grid.emit()
		GameData.yin = false
		GameData.yang = false
	elif GameData.yang:
		yin_yang.texture = YANG
	elif GameData.yin:
		yin_yang.texture = YIN
	else:
		yin_yang.texture = null


func update_amount() -> void:
	use_amount_label.text = str(GameData.paint_bombs)


func update_currency_label(delta_coins: float = 0) -> void:
	print(GameData.player_currency, "+", delta_coins)
	var currency: int = int(GameData.get("player_currency"))
	if delta_coins == 0:
		currency_label.text = str(currency, " coins")
	elif delta_coins > 0:
		currency_label.text = str(currency, " coins +(", delta_coins, ")")
	elif delta_coins < 0:
		currency_label.text = str(currency, " coins -(", abs(delta_coins), ")")


func update_percentage_label(percentage: float) -> void:
	percentage_label.add_theme_color_override("font_color", Color.BLACK)
	percentage_label.text = str(percentage * 100, "%")
	percentage_bar.value = percentage * 100
	
	var bar_color = Color.GREEN.lerp(Color.RED, 1.0 - percentage)
	percentage_bar.tint_progress = bar_color
