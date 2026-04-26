extends Control
@onready var currency_label: Label = %CurrencyLabel
@onready var percentage_label: Label = %PercentageLabel
@onready var percentage_bar: TextureProgressBar = %PercentageBar
@onready var use_amount_label: Label = %UseAmountLabel



func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)
	SignalManager.percentage_changed.connect(update_percentage_label)
	SignalManager.bomb_amount_changed.connect(update_amount)
	
	custom_minimum_size = Vector2(200, 30) # Width, Height
	percentage_bar.nine_patch_stretch = true
	
	
	update_currency_label()
	update_amount()
	
	
	

func update_amount() -> void:
	use_amount_label.text = str(GameData.paint_bombs)


func update_currency_label(delta_coins: float = 0) -> void:
	print(GameData.player_currency, "+", delta_coins)
	var currency: int = int(GameData.get("player_currency"))
	if delta_coins == 0:
		currency_label.text = str(currency, " coins")
	elif delta_coins > 0:
		currency_label.text = str(currency, " coins +(", delta_coins, ")")
	elif delta_coins > 0:
		currency_label.text = str(currency, " coins -(", abs(delta_coins), ")")


func update_percentage_label(percentage: float) -> void:
	percentage_label.add_theme_color_override("font_color", Color.BLACK)
	percentage_label.text = str(percentage * 100, "%")
	percentage_bar.value = percentage * 100
	
	var bar_color = Color.GREEN.lerp(Color.RED, 1.0 - percentage)
	percentage_bar.tint_progress = bar_color
