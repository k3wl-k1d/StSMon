class_name CharacterStats
extends Stats

enum Typing {NORMAL, FIRE, WATER, GRASS, ELECTRIC, PSYCHIC, GROUND, ROCK, FIGHTING, STEEL, FAIRY, DARK, FLYING, ICE, POISON, GHOST, DRAGON, BUG, NONE}

@export_group("Gameplay")
@export var primaryType: Typing
@export var secondaryType: Typing
@export var startingDeck: CardPile
@export var draftableCardsPrimaryType: CardPile
@export var draftableCardsSecondaryType: CardPile
@export var cardsPerTurn: int
@export var maxMana: int
@export var startingRelic: Relic

@export_group("Visuals")
@export var hurtIcon: Texture
@export var faintIcon: Texture
@export_multiline var description: String
@export_multiline var credits: String

var mana: int: set = set_mana
var isHealthy := true
var isAlive := true
var baseIcon: Texture = icon

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()

func reset_mana() -> void:
	self.mana = maxMana

func take_damage(damage: int) -> void:
	var initialHealth := health
	var newIcon := baseIcon
	super.take_damage(damage)
	update_health_condition()
	
	if isAlive and isHealthy:
		newIcon = baseIcon
	elif isAlive and not isHealthy:
		newIcon = hurtIcon
	else:
		newIcon = faintIcon
	if newIcon != icon:
		icon = newIcon
	
	if initialHealth > health:
		Events.player_hit_without_block.emit()

func can_play_card(card: Card) -> bool:
	return mana >= card.cost and check_typings(card)

func check_typings(card: Card) -> bool:
	if primaryType == card.typing or secondaryType == card.typing or card.typing == Card.Typing.NORMAL or has_typing(Typing.NORMAL):
		return true
	return false

func update_health_condition() -> void:
	if health > 0:
		isAlive = true
		isHealthy = health > maxHealth/2
	else:
		isAlive = false
		isHealthy = false

func has_typing(type: Typing) -> bool:
	return primaryType == type or secondaryType == type

# Create an instance for a character
func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = maxHealth
	instance.block = 0
	instance.speed = entitySpeed
	instance.baseIcon = icon
	instance.reset_mana()
	return instance
