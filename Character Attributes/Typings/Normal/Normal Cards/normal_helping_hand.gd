extends Card

const STRENGTH_STATUS := preload("res://Statuses/strength.tres")

var stacks := 1

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var strength := STRENGTH_STATUS.duplicate()
	strength.stacks = stacks
	statusEffect.status = strength
	statusEffect.execute(targets)
