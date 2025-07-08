class_name ModifierValue
extends Node

enum Type {FLAT, PERCENT}

@export var type: Type
@export var flatValue: int
@export var percentValue: float
@export var source: String

static func create_new_modifier(modifierSource: String, whatType: Type) -> ModifierValue:
	var newModifier := new()
	newModifier.source = modifierSource
	newModifier.type = whatType
	
	return newModifier
