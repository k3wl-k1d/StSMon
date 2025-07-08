class_name Modifier
extends Node

enum Type {DMG_DEALT, DMG_TAKEN, CARD_COST, SHOP_COST, NO_MODIFIER, ALLY_REDIRECTION, SPEED}

@export var type: Type

func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source == source:
			return value
	
	return null

func add_new_value(value: ModifierValue) -> void:
	var modifierValue := get_value(value.source)
	if not modifierValue:
		add_child(value)
	else:
		modifierValue.flatValue = value.flatValue
		modifierValue.percentValue = value.percentValue

func remove_value(source: String) -> void:
	for value: ModifierValue in get_children():
		if value.source == source:
			value.queue_free()

func clear_all_values() -> void:
	for value: ModifierValue in get_children():
		value.queue_free()

func get_modified_value(base: int) -> int:
	var flatResult: int = base
	var percentResult: float = 1.0
	# Apply flat modifiers first
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.FLAT:
			flatResult += value.flatValue
	
	# Now apply percent modifiers
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.PERCENT:
			percentResult += value.percentValue
	
	return floori(flatResult * percentResult)
