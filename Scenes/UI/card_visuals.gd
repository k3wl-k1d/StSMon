class_name CardVisuals
extends Control

@export var card: Card: set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $CardIcon
@onready var rarity: TextureRect = $Rarity
@onready var cardName: Label = $CardName

var baseStyleBox: StyleBoxFlat
var dragStyleBox: StyleBoxFlat
var hoverStyleBox: StyleBoxFlat

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	baseStyleBox = card.cardBaseStylebox
	dragStyleBox = card.cardDragStylebox
	hoverStyleBox = card.cardHoverStylebox
	panel.set("theme_override_styles/panel", baseStyleBox)
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLOURS[card.rarity]
	cardName.text = card.cardName
