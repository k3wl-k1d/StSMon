class_name CardPileView
extends Control

const CARD_MENU_UI_SCENE := preload("res://Scenes/CardMenuUI/card_menu_ui.tscn")

@export var cardPile: CardPile

@onready var title: Label = %Title
@onready var cards: GridContainer = %Cards
@onready var cardTooltipPopup: CardTooltipPopup = %CardTooltipPopup
@onready var backButton: Button = %BackButton

func _ready() -> void:
	backButton.pressed.connect(hide)
	
	for card: Node in cards.get_children():
		card.queue_free()
	
	cardTooltipPopup.hide_tooltip()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if cardTooltipPopup.visible:
			cardTooltipPopup.hide_tooltip()
		else:
			hide()

func show_current_view(newTitle: String, randomized: bool = false) -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	cardTooltipPopup.hide_tooltip()
	title.text = newTitle
	_update_view.call_deferred(randomized)

func _update_view(randomized: bool) -> void:
	if not cardPile:
		return
	
	var allCards := cardPile.cards.duplicate()
	if randomized:
		RNG.array_shuffle(allCards)
	
	for card: Card in allCards:
		var newCard := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
		cards.add_child(newCard)
		newCard.card = card
		newCard.tooltip_requested.connect(cardTooltipPopup.show_tooltip)
	
	show()
