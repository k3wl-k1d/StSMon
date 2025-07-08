extends Card

var baseDamage := 0

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	if not targets[0].statusHandler._has_status("poison"):
		SFXPlayer.play(sound)
		return
	
	baseDamage = targets[0].statusHandler._get_status("poison").stacks
	var damageEffect := DamageEffect.new()
	damageEffect.amount = baseDamage
	damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
	damageEffect.sound = sound
	damageEffect.execute(targets)
