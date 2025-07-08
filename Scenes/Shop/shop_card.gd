class_name ShopCard
extends VBoxContainer

const CARD_MENU_UI := preload("res://Scenes/CardMenuUI/card_menu_ui.tscn")

@export var card: Card: set = set_card

@onready var cardContainer: CenterContainer = %CardContainer
@onready var price: HBoxContainer = %Price
@onready var priceLabel: Label = %PriceLabel
@onready var button: Button = $Button
@onready var goldCost := {
	Card.Rarity.COMMON : RNG.instance.randi_range(40, 99),
	Card.Rarity.RARE : RNG.instance.randi_range(89, 149),
	Card.Rarity.MYTHICAL : RNG.instance.randi_range(140, 249)
}

var currentCardUI: CardMenuUI

func update(runStats: RunStats) -> void:
	if not cardContainer or not price or not button:
		return
	
	priceLabel.text = str(goldCost[card.rarity])
	
	if runStats.gold >= goldCost[card.rarity]:
		priceLabel.remove_theme_color_override("font_color")
		button.disabled = false
	else:
		priceLabel.add_theme_color_override("font_color", Color.RED)
		button.disabled = true

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	
	for cardMenuUI: CardMenuUI in cardContainer.get_children():
		cardMenuUI.queue_free()
	
	var newCardMenuUI := CARD_MENU_UI.instantiate() as CardMenuUI
	cardContainer.add_child(newCardMenuUI)
	newCardMenuUI.card = card
	currentCardUI = newCardMenuUI

func _on_button_pressed() -> void:
	Events.shop_card_bought.emit(card, goldCost[card.rarity])
	cardContainer.queue_free()
	price.queue_free()
	button.queue_free()
