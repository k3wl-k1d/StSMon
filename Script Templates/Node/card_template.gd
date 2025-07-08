# meta-name: Card Logic
# meta-description: What happens when a card is played
extends Card

@export var optionalSound: AudioStream

func get_default_tooltip() -> String:
	return tooltip

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	print("Card has been played!")
	print("Targets: %s" % targets)
