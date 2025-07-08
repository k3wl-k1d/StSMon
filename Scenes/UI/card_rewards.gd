class_name CardRewards
extends ColorRect

signal card_reward_selected(card: Card)

const CARD_MENU_UI := preload("res://Scenes/CardMenuUI/card_menu_ui.tscn")

@export var rewards: Array[Card]: set = set_rewards

@onready var cards: HBoxContainer = %Cards
@onready var skipCardReward: Button = %SkipCardReward
@onready var cardTooltipPopup: CardTooltipPopup = $CardTooltipPopup
@onready var takeButton: Button = %TakeButton

var selectedCard: Card

func _ready() -> void:
	_clear_rewards()
	
	takeButton.pressed.connect(
		func():
			card_reward_selected.emit(selectedCard)
			print("Drafted %s" % selectedCard.id)
			queue_free()
	)
	
	skipCardReward.pressed.connect(
		func():
			card_reward_selected.emit(null)
			print("Skipped card reward")
			queue_free()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cardTooltipPopup.hide_tooltip()

func _clear_rewards() -> void:
	for card: Node in cards.get_children():
		card.queue_free()
	
	cardTooltipPopup.hide_tooltip()
	selectedCard = null

func _show_tooltip(card: Card) -> void:
	selectedCard = card
	cardTooltipPopup.show_tooltip(card)

func set_rewards(value: Array[Card]) -> void:
	rewards = value
	
	if not is_node_ready():
		await ready
	
	_clear_rewards()
	for card: Card in rewards:
		var newCard := CARD_MENU_UI.instantiate() as CardMenuUI
		cards.add_child(newCard)
		newCard.card = card
		newCard.tooltip_requested.connect(_show_tooltip)
