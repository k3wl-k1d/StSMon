extends Card

const CURSE_STATUS := preload("res://Statuses/curse.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var curse := CURSE_STATUS.duplicate()
	
	curse.stacks = targets[0].statusHandler._get_status("curse").stacks
	statusEffect.status = curse
	statusEffect.execute(targets)
