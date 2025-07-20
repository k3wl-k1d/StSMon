extends Card

const CURSE_STATUS := preload("res://Statuses/curse.tres")

var curseAmount := 4

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var curse := CURSE_STATUS.duplicate()
	curse.stacks = curseAmount
	statusEffect.status = curse
	statusEffect.execute(targets)
