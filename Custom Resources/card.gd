class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, ALLY, TEAM, SINGLE_ENEMY, ALL_ENEMY, EVERYONE}
enum Rarity {COMMON, RARE, MYTHICAL}
enum Typing {NORMAL, FIRE, WATER, GRASS, ELECTRIC, PSYCHIC, GROUND, ROCK, FIGHTING, STEEL, FAIRY, DARK, FLYING, ICE, POISON, GHOST, DRAGON, BUG}

const RARITY_COLOURS := {
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.RARE: Color.GOLDENROD,
	Card.Rarity.MYTHICAL: Color.AQUA
}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var rarity: Rarity
@export var typing: Typing
@export var cost: int
@export var exhaust: bool = false
@export var removeAfterCombat: bool = false

@export_group("Card Visuals")
@export var cardName: String
@export var icon: Texture
@export_multiline var tooltip: String
@export var sound: AudioStream
@export var cardBaseStylebox: StyleBox
@export var cardDragStylebox: StyleBox
@export var cardHoverStylebox: StyleBox

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		print("ERROR: card.gd _get_targets returns: No valid targets")
		return []
	
	var tree := targets[0].get_tree()
	
	match target:
		Target.TEAM:
			print("card.gd _get_targets returns: \"player\" group\n")
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMY:
			print("card.gd _get_targets returns: \"enemies\" group\n")
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			print("card.gd _get_targets returns: \"player\" + \"enemies\" group\n")
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			print("card.gd _get_targets returns: default\n")
			return []

func play(targets: Array[Node], charStats: CharacterStats, modifiers: ModifierHandler, standardCard: bool = true) -> void:
	if standardCard:
		Events.card_played.emit(self)
		increase_crit_chance()
		charStats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets, modifiers)
	elif target == Target.SELF and PokemonTeam.active.stats == charStats:
		apply_effects([PokemonTeam.active], modifiers)
	elif target == Target.ALLY:
		var ally: Array[Node] = PokemonTeam.players.duplicate()
		ally.erase(PokemonTeam.active)
		apply_effects(ally, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)

func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass

func increase_crit_chance() -> void:
	Events.increase_crit.emit(1)

func get_default_tooltip() -> String:
	return tooltip

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip
