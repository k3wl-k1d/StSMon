class_name PokemonTeam
extends Node

const STARTER_DECK := preload("res://Character Attributes/starting_deck.tres")

static var teammate1: CharacterStats
static var teammate2: CharacterStats
static var players: Array[Node]
static var active: Player
static var fainted: Array[Node]

static var deck := STARTER_DECK.custom_duplicate()
static var discard: CardPile
static var drawPile: CardPile

const CRIT_CHARGE_MAX := 10
static var critMeter := 0

# Item-specific data
static var totalTeammateDeaths: int = 0

static func set_deck() -> void:
	if not teammate1 or not teammate2:
		return
	if not Events.player_died.is_connected(_on_player_died):
		Events.player_died.connect(_on_player_died)
	if not Events.player_revived.is_connected(_on_player_revived):
		Events.player_revived.connect(_on_player_revived)
	if not Events.increase_crit.is_connected(increase_crit):
		Events.increase_crit.connect(increase_crit)
	if not Events.reset_crit.is_connected(_on_crit_reset):
		Events.reset_crit.connect(_on_crit_reset)
	
	deck.merge_decks(teammate1.startingDeck)
	deck.merge_decks(teammate2.startingDeck)

static func reset_game() -> void:
	critMeter = 0
	totalTeammateDeaths = 0
	deck = STARTER_DECK.custom_duplicate()
	discard = null
	drawPile = null
	teammate1 = null
	teammate2 = null
	players = [null]
	active = null
	fainted = [null]

static func revive_players() -> void:
	if fainted.size() == 0:
		return
	
	var player := fainted[0] as Player
	player.stats.heal(ceili(player.stats.maxHealth * 0.1))
	fainted.clear()

static func get_player(playerName: String) -> Player:
	for p: Player in players:
		if p.stats.name == playerName:
			return p
	return null

static func increase_crit(amount: int) -> void:
	critMeter = clampi(critMeter + amount, 0, CRIT_CHARGE_MAX)
	
	if critMeter >= CRIT_CHARGE_MAX:
		Events.crit_ready.emit()

static func set_crit(amount: int) -> void:
	critMeter = clampi(amount, 0, CRIT_CHARGE_MAX)
	
	if critMeter >= CRIT_CHARGE_MAX:
		Events.crit_ready.emit()

static func _on_crit_reset() -> void:
	critMeter = 0

static func check_team_evolutions() -> void:
	if teammate1.evolution.check_evolution():
		Events.evolving.emit(teammate1)
	if teammate2.evolution.check_evolution():
		Events.evolving.emit(teammate2)

static func _on_player_died(player: Player) -> void:
	player.statusHandler.clear_statuses()
	fainted.append(player)
	totalTeammateDeaths += 1
	print("Player dead: ", player)
	if fainted.size() == 2 and fainted.has(players[0]) and fainted.has(players[1]):
		Events.both_players_died.emit()

static func _on_player_revived(player: Player) -> void:
	fainted.erase(player)
	player.stats.health = clampi(player.stats.health, 1, player.stats.maxHealth)
	player.stats.update_health_condition()
