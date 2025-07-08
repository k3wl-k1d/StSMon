class_name ParalysisStatus
extends Status

const SPEED_REDUCTION := 0.5

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var speedModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.SPEED)
	assert(speedModifier, "No speed modifier on %s" % target)
	
	var paraModifier := speedModifier.get_value("paralysis")
	
	if not paraModifier:
		paraModifier = ModifierValue.create_new_modifier("paralysis", ModifierValue.Type.PERCENT)
		paraModifier.percentValue = SPEED_REDUCTION
		speedModifier.add_new_value(paraModifier)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(speedModifier))

func _on_status_changed(speedModifier: Modifier) -> void:
	if duration <= 0 and speedModifier:
		speedModifier.remove_value("paralysis")

func get_tooltip() -> String:
	return tooltip % duration
