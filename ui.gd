extends Control
@onready var currency_label: Label = %CurrencyLabel
@onready var percentage_label: Label = %PercentageLabel
@export var gradient: Gradient


func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)
	SignalManager.percentage_changed.connect(update_percentage_label)
	update_currency_label()


func update_currency_label() -> void:
	var currency: int = int(GameData.get("player_currency"))
	currency_label.text = str(currency, " coins")


func update_percentage_label(percentage: float) -> void:
	var color = gradient.sample(0.75)
	percentage_label.add_theme_color_override("font_color", Color.RED)
	percentage_label.text = str(percentage * 100, "%")
