extends Control
@onready var currency_label: Label = $PanelContainer/CurrencyLabel



func _ready() -> void:
	SignalManager.currency_changed.connect(update_currency_label)
	update_currency_label()


func update_currency_label() -> void:
	var currency: int = int(GameData.get("player_currency"))
	currency_label.text = str(currency, " coins")
