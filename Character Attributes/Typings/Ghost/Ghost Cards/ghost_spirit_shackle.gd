extends Card

const CURSE_STATUS := preload("res://Statuses/curse.tres")

var curseStacks := 8

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var statusEffect := StatusEffect.new()
	var curse := CURSE_STATUS.duplicate()
	
	curse.stacks = curseStacks
	statusEffect.status = curse
	statusEffect.execute(targets)
	
	damageEffect.amount = targets[0].statusHandler._get_status("curse").stacks
	damageEffect.sound = sound
	damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
	damageEffect.execute(targets)
