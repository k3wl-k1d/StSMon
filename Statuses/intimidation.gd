class_name IntimidationStatus
extends Status

const MODIFIER := -0.25

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var dmgReductionModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmgReductionModifier, "No dmg dealt modifier on %s" % target)
	
	var intimModiferValue := dmgReductionModifier.get_value("intimidation")
	
	if not intimModiferValue:
		intimModiferValue = ModifierValue.create_new_modifier("intimidation", ModifierValue.Type.PERCENT)
		intimModiferValue.percentValue = MODIFIER
		dmgReductionModifier.add_new_value(intimModiferValue)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmgReductionModifier))

func _on_status_changed(dmgReductionModifier: Modifier) -> void:
	if duration <= 0 and dmgReductionModifier:
		dmgReductionModifier.remove_value("intimidation")

func apply_status(target: Node) -> void:
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % duration
