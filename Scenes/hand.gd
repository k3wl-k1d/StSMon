class_name Hand
extends HBoxContainer

const CARD = preload("res://Scenes/CardUI/card_ui.tscn")

@onready var cardUI := preload("res://Scenes/CardUI/card_ui.tscn")

@export var handCurve: Curve
@export var rotationCurve: Curve
@export var maxRotationDegrees := 5
@export var xSeperation := -10
@export var yMin := 0
@export var yMax := -15

var cardsPlayedThisTurn := 0

func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func add_card(card: Card) -> void:
	var newCardUI := cardUI.instantiate()
	add_child(newCardUI)
	newCardUI.reparent_requested.connect(_on_card_ui_reparent_requested)
	newCardUI.card = card
	newCardUI.parent = self
	newCardUI.charStats = PokemonTeam.active.stats
	newCardUI.playerModifiers = PokemonTeam.active.modifierHandler

func discard_card(card: CardUI) -> void:
	card.queue_free()

func disable_hand() -> void:
	for card in get_children():
		card.disabled = true

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disabled = true
	child.reparent(self)
	var newIndex := clampi(child.originalIndex, 0, get_child_count())
	move_child.call_deferred(child, newIndex)
	child.disabled = false

func _on_card_played(_card: Card) -> void:
	cardsPlayedThisTurn += 1
