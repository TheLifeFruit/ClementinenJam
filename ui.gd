extends Control

@onready var currency_label: Label = $CurrencyLabel


func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)


func update_currency_label() -> void:
	currency_label.text = str(GameData.player_currency, " coins")
