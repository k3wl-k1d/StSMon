class_name HasteStatus
extends Status

@export var speedBoost := 0.1

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifierHandler"), "No modifiers on %s" % target)
	
	var speedModifier: Modifier = target.modifierHandler.get_modifier(Modifier.Type.SPEED)
	assert(speedModifier, "No speed dealt modifier on %s" % target)
	
	var hasteModifierValue := speedModifier.get_value("haste")
	
	if not hasteModifierValue:
		hasteModifierValue = ModifierValue.create_new_modifier("haste", ModifierValue.Type.PERCENT)
	
	hasteModifierValue.percentValue = 1 + ceili(stacks * speedBoost)
	speedModifier.add_new_value(hasteModifierValue)

func get_tooltip() -> String:
	return tooltip % ceili(stacks * 5)
