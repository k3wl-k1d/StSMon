class_name BattleUI
extends CanvasLayer

@export var charStatsP1: CharacterStats : set = _set_char_stats_P1
@export var charStatsP2: CharacterStats : set = _set_char_stats_P2

@onready var hand: Hand = $Hand as Hand
@onready var manaUI: ManaUI = $ManaUI as ManaUI
@onready var endTurnButton: Button = %EndTurnButton
@onready var drawPileButton: CardPileOpener = %DrawPileButton
@onready var discardPileButton: CardPileOpener = %DiscardPileButton
@onready var drawPileView: CardPileView = %DrawPileView
@onready var discardPileView: CardPileView = %DiscardPileView

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	endTurnButton.pressed.connect(_on_end_turn_button_pressed)
	drawPileButton.pressed.connect(drawPileView.show_current_view.bind("Draw Pile", true))
	discardPileButton.pressed.connect(discardPileView.show_current_view.bind("Discard Pile"))

func initialize_card_pile_ui() -> void:
	drawPileButton.cardPile = PokemonTeam.drawPile
	drawPileView.cardPile = PokemonTeam.drawPile
	discardPileButton.cardPile = PokemonTeam.discard
	discardPileView.cardPile = PokemonTeam.discard

func _set_char_stats_P1(value: CharacterStats) -> void:
	charStatsP1 = value
	manaUI.charStatsP1 = charStatsP1

func _set_char_stats_P2(value: CharacterStats) -> void:
	charStatsP2 = value
	manaUI.charStatsP2 = charStatsP2

func _on_player_hand_drawn() -> void:
	endTurnButton.disabled = false

func _on_end_turn_button_pressed() -> void:
	endTurnButton.disabled = true
	Events.player_turn_ended.emit()
