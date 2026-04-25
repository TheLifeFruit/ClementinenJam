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
	var currency: int = int(GameData.get("player_currency"))
	currency_label.text = str(currency, " coins")


func update_percentage_label(percentage: float) -> void:
	percentage_label.add_theme_color_override("font_color", Color.BLACK)
	percentage_label.text = str(percentage * 100, "%")
	percentage_bar.value = percentage * 100
	
	var bar_color = Color.GREEN.lerp(Color.RED, 1.0 - percentage)
	percentage_bar.tint_progress = bar_color


func update_bar_color(percentage: float) -> void:
	# .sample() picks the color based on the 0.0-1.0 value
	var current_color = gradient.sample(percentage)
	percentage_bar.tint_progress = current_color
