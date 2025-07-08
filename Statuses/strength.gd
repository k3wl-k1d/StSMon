class_name StrengthStatus
extends Status

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgDealtModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmgDealtModifier, "No dmg dealt modifier on %s" % target)
	
	var strengthModiferValue := dmgDealtModifier.get_value("strength")
	
	if not strengthModiferValue:
		strengthModiferValue = ModifierValue.create_new_modifier("strength", ModifierValue.Type.FLAT)
	
	strengthModiferValue.flatValue = stacks
	dmgDealtModifier.add_new_value(strengthModiferValue)

func get_tooltip() -> String:
	return tooltip % stacks
