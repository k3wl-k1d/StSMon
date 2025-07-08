extends Card

var healAmount := 6

func get_default_tooltip() -> String:
	return tooltip % healAmount

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip % healAmount

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	targets[0].stats.heal(healAmount)
	SFXPlayer.play(sound)
