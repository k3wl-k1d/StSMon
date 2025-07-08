class_name ExposedStatus
extends Status

const MODIFIER := 0.5

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgTakenModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmgTakenModifier, "No dmg taken modifier on %s" % target)
	
	var exposedModifierValue := dmgTakenModifier.get_value("exposed")
	
	if not exposedModifierValue:
		exposedModifierValue = ModifierValue.create_new_modifier("exposed", ModifierValue.Type.PERCENT)
		exposedModifierValue.percentValue = MODIFIER
		dmgTakenModifier.add_new_value(exposedModifierValue)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmgTakenModifier))

func _on_status_changed(dmgTakenModifier: Modifier) -> void:
	if duration <= 0 and dmgTakenModifier:
		dmgTakenModifier.remove_value("exposed")

func get_tooltip() -> String:
	return tooltip % duration
