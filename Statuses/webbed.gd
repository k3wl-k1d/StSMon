class_name WebbedStatus
extends Status

const MODIFIER := 0.25

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var speedModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.SPEED)
	assert(speedModifier, "No speed modifier on %s" % target)
	
	var webbedModifier := speedModifier.get_value("webbed")
	
	if not webbedModifier:
		webbedModifier = ModifierValue.create_new_modifier("webbed", ModifierValue.Type.PERCENT)
		webbedModifier.percentValue = MODIFIER
		speedModifier.add_new_value(webbedModifier)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(speedModifier))

func _on_status_changed(speedModifier: Modifier) -> void:
	if duration <= 0 and speedModifier:
		speedModifier.remove_value("webbed")

func get_tooltip() -> String:
	return tooltip % duration
