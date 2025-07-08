class_name CurseStatus
extends Status

var curseStacks := 0

func apply_status(target: Node) -> void:
	curseStacks = target.statusHandler._get_status("curse").stacks
	var damageEffect := DamageEffect.new()
	damageEffect.amount = curseStacks
	damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
	damageEffect.execute([target])
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % stacks
