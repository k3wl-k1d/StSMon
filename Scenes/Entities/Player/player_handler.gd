# Player turn order:
# 1. START_OF_TURN Relics
# 2. START_OF_TURN Statuses
# 3. Draw hand
# 4. End turn
# 5. END_OF_TURN Relics
# 6. END_OF_TURN Statuses
# 7. Discard hand

class_name PlayerHandler
extends Node2D

const HAND_DRAWN_INTERVAL := 0.2
const HAND_DISCARD_INTERVAL := 0.25

@onready var player1: Player = $Player as Player
@onready var player2: Player = $Player2 as Player

@export var relics: RelicHandler
@export var hand: Hand

var skipTurn := false
var crit := false

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.crit_ready.connect(_on_crit_ready)
	Events.skip_current_turn.connect(func(target):
		if target is Player:
			skipTurn = true)

func start_battle(charStatsP1: CharacterStats, charStatsP2: CharacterStats) -> void:
	player1.stats = charStatsP1
	player2.stats = charStatsP2
	player1.statusHandler.statuses_applied.connect(_on_statuses_applied)
	player2.statusHandler.statuses_applied.connect(_on_statuses_applied)
	relics.relics_activated.connect(_on_relics_activated)
	
	PokemonTeam.drawPile = PokemonTeam.deck.custom_duplicate()
	PokemonTeam.drawPile.shuffle()
	PokemonTeam.discard = CardPile.new()

func start_turn(member: Player) -> void:
	if not member:
		return
	member.stats.block = 0
	member.stats.reset_mana()
	member.arrow.show()
	relics.activate_relics_by_type(Relic.Type.START_OF_TURN)

func end_turn() -> void:
	hand.disable_hand()
	relics.activate_relics_by_type(Relic.Type.END_OF_TURN)

func draw_card() -> void:
	reshuffle_deck_from_discard()
	var card := PokemonTeam.drawPile.draw_card()
	hand.add_card(card)
	Events.player_card_drawn.emit(card)
	reshuffle_deck_from_discard()

# Draw n cards
func draw_cards(amount: int) -> void:
	if skipTurn:
		Events.player_hand_drawn.emit()
		end_turn()
		skipTurn = false
		return
	
	if amount <= 0:
		print("Error card draw amount: %d" % amount)
		return
	
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAWN_INTERVAL)
	
	tween.finished.connect(
		func(): 
			Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	if hand.get_children().size() <= 0:
		Events.player_hand_discarded.emit()
		return
	var tween := create_tween()
	for cardUI in hand.get_children():
		tween.tween_callback(PokemonTeam.discard.add_card.bind(cardUI.card))
		tween.tween_callback(hand.discard_card.bind(cardUI))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not PokemonTeam.drawPile.empty():
		return
	
	while not PokemonTeam.discard.empty():
		PokemonTeam.drawPile.add_card(PokemonTeam.discard.draw_card())
	
	PokemonTeam.drawPile.shuffle()

func _on_card_played(card: Card) -> void:
	# Do not put exhausted cards back in
	if card.exhaust or card.type == Card.Type.POWER:
		return
	
	if crit:
		crit = false
		return
	
	PokemonTeam.discard.add_card(card)

func _on_crit_ready() -> void:
	crit = true

func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_TURN:
			PokemonTeam.active.statusHandler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		Relic.Type.END_OF_TURN:
			PokemonTeam.active.statusHandler.apply_statuses_by_type(Status.Type.END_OF_TURN)

func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			draw_cards(PokemonTeam.active.stats.cardsPerTurn)
		Status.Type.END_OF_TURN:
			PokemonTeam.active.arrow.hide()
			discard_cards()
