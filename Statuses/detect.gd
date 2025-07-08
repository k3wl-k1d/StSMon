class_name DetectStatus
extends Status

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgTakenModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmgTakenModifier, "No dmg taken modifier on %s" % target)
	
	var detectModifierValue := dmgTakenModifier.get_value("detect")
	
	if not detectModifierValue:
		detectModifierValue = ModifierValue.create_new_modifier("detect", ModifierValue.Type.FLAT)
	
	detectModifierValue.flatValue = -stacks
	dmgTakenModifier.add_new_value(detectModifierValue)

func get_tooltip() -> String:
	return tooltip % stacks
