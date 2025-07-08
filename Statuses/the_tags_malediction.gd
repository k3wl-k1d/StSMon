class_name MaledictionStatus
extends Status

const MODIFIER := -0.50

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgDealtModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmgDealtModifier, "No dmg dealt modifier on %s" % target)
	
	var strengthModiferValue := dmgDealtModifier.get_value("malediction")
	
	if not strengthModiferValue:
		strengthModiferValue = ModifierValue.create_new_modifier("malediction", ModifierValue.Type.PERCENT)
	strengthModiferValue.percentValue = MODIFIER
	dmgDealtModifier.add_new_value(strengthModiferValue)

func apply_status(target: Node) -> void:
	status_applied.emit(self)
