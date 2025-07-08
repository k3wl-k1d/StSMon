class_name BurnStatus
extends Status

const MODIFIER := -0.25
const DAMAGE := 0.1

@export var baseDamage := 4

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgDealtModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmgDealtModifier, "No dmg dealt modifier on %s" % target)
	
	var strengthModiferValue := dmgDealtModifier.get_value("burn")
	
	if not strengthModiferValue:
		strengthModiferValue = ModifierValue.create_new_modifier("burn", ModifierValue.Type.PERCENT)
	
	strengthModiferValue.percentValue = 1 + MODIFIER
	dmgDealtModifier.add_new_value(strengthModiferValue)

func apply_status(target: Node) -> void:
	var damageEffect := DamageEffect.new()
	if target.stats:
		damageEffect.amount = ceili(target.stats.maxHealth * DAMAGE)
	else:
		print("!!ERROR!!\ttarget.stats could not be acquired. USING BASE")
		damageEffect.amount = baseDamage
	damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
	damageEffect.execute([target])
	
	status_applied.emit(self)
