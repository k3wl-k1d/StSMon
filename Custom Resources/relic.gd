class_name Relic
extends Resource

enum Type {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, EVENT_BASED}
enum CharacterType {ALL, MUNCHLAX, GIMMIGHOUL, FOONGUS, NOIBAT}
enum Typing {ALL, NORMAL, FIRE, WATER, GRASS, ELECTRIC, PSYCHIC, GROUND, ROCK, FIGHTING, STEEL, FAIRY, DARK, FLYING, ICE, POISON, GHOST, DRAGON, BUG}

@export var relicName: String
@export var id: String
@export var type: Type
@export var characterType: CharacterType
@export var typing: Typing
@export var starter: bool = false
@export var consumable: bool = false
@export var shouldDisplayStacks: bool = false
@export var baseStacks: int = 0
@export var currentStacks: int = 0
@export var icon: Texture
@export_multiline var tooltip: String

func initialize_relic(_owner: RelicUI) -> void:
	pass

func activate_relic(_owner: RelicUI) -> void:
	pass

# This method should be implemented for event-based relics
# which connects the relic to the Events to disconnect them when a relic is removed
func deactivate_relic(_owner: RelicUI) -> void:
	pass

func get_tooltip() -> String:
	return tooltip

# Returns whether or not a relic can appear as a reward
func can_appear_as_reward(c1: CharacterStats, c2: CharacterStats) -> bool:
	if not c1 or not c2:
		print("ERROR: can_appear_as_reward() recieved a null value: \n\tC1: %s\n\tC2: %s" % [c1, c2])
		return false
	if starter:
		return false
	if characterType == CharacterType.ALL:
		return true
	
	var relicChar: String = CharacterType.keys()[characterType].to_lower()
	var char1 := c1.name.to_lower()
	var char2 := c2.name.to_lower()
	return relicChar == char1 or relicChar == char2
