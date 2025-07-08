extends Card

const POISON_STATUS := preload("res://Statuses/poison.tres")

var poisonStacks := 6

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var poison := POISON_STATUS.duplicate()
	poison.stacks = poisonStacks
	statusEffect.status = poison
	statusEffect.execute(targets)
	SFXPlayer.play(sound)
