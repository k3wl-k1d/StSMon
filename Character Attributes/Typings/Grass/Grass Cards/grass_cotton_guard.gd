extends Card

var healing := 0

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	healing = targets[0].stats.block
	targets[0].stats.heal(healing)
	targets[0].stats.block = 0
	SFXPlayer.play(sound)
