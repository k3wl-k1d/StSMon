class_name SpotlightStatus
extends Status

var spotlightTarget: Node

func initialize_status(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var redirectModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.ALLY_REDIRECTION)
	assert(redirectModifier, "No redirect modifier on %s" % target)
	
	var spotlightModifier := redirectModifier.get_value("spotlight")
	
	if not spotlightModifier:
		spotlightModifier = ModifierValue.create_new_modifier("spotlight", ModifierValue.Type.FLAT)
	
	spotlightModifier.flatValue = stacks
	redirectModifier.add_new_value(spotlightModifier)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(redirectModifier))

func apply_status(target: Node) -> void:
	spotlightTarget = target
	Events.spotlight_active.emit(spotlightTarget)
	status_applied.emit(self)

func _on_status_changed(redirectModifier: Modifier) -> void:
	if duration <= 0 and redirectModifier and spotlightTarget:
		redirectModifier.remove_value("spotlight")
		Events.spotlight_deactive.emit(spotlightTarget)

func get_tooltip() -> String:
	return tooltip % duration
