class_name GuardedStatus
extends Status

const MODIFIER := 1.5

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgTakenModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmgTakenModifier, "No dmg taken modifier on %s" % target)
	
	var guardedModifierValue := dmgTakenModifier.get_value("guarded")
	
	if not guardedModifierValue:
		guardedModifierValue = ModifierValue.create_new_modifier("guarded", ModifierValue.Type.PERCENT)
		guardedModifierValue.percentValue = MODIFIER
		dmgTakenModifier.add_new_value(guardedModifierValue)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmgTakenModifier))

func _on_status_changed(dmgTakenModifier: Modifier) -> void:
	if duration <= 0 and dmgTakenModifier:
		dmgTakenModifier.remove_value("guarded")

func get_tooltip() -> String:
	return tooltip % duration
