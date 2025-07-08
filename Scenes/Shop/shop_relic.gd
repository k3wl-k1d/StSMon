class_name ShopRelic
extends VBoxContainer

const RELIC_UI := preload("res://Scenes/RelicHandler/relic_ui.tscn")

@export var relic: Relic: set = set_relic

@onready var relicContainer: CenterContainer = %RelicContainer
@onready var price: HBoxContainer = %Price
@onready var priceLabel: Label = %PriceLabel
@onready var button: Button = $Button
@onready var goldCost := RNG.instance.randi_range(140,320)

func update(runStats: RunStats) -> void:
	if not relicContainer or not price or not button:
		return
	
	priceLabel.text = str(goldCost)
	
	if runStats.gold >= goldCost:
		priceLabel.remove_theme_color_override("font_color")
		button.disabled = false
	else:
		priceLabel.add_theme_color_override("font_color", Color.RED)
		button.disabled = true

func set_relic(value: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = value
	
	for relicUI: RelicUI in relicContainer.get_children():
		relicUI.queue_free()
	
	var newRelicUI := RELIC_UI.instantiate() as RelicUI
	relicContainer.add_child(newRelicUI)
	newRelicUI.relic = relic

func _on_button_pressed() -> void:
	Events.shop_relic_bought.emit(relic, goldCost)
	relicContainer.queue_free()
	price.queue_free()
	button.queue_free()
