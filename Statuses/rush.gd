class_name RushStatus
extends Status

const MODIFIER := 1.15

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var speedModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.SPEED)
	assert(speedModifier, "No speed modifier on %s" % target)
	
	var rushModifier := speedModifier.get_value("rush")
	
	if not rushModifier:
		rushModifier = ModifierValue.create_new_modifier("rush", ModifierValue.Type.PERCENT)
		rushModifier.percentValue = MODIFIER
		speedModifier.add_new_value(rushModifier)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(speedModifier))

func _on_status_changed(speedModifier: Modifier) -> void:
	if duration <= 0 and speedModifier:
		speedModifier.remove_value("rush")

func get_tooltip() -> String:
	return tooltip % duration
