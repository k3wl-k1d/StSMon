class_name SharpenPower
extends Status

const STRENGTH_STATUS := preload("res://Statuses/strength.tres")

var stacksPerTurn := 2

func apply_status(target: Node) -> void:
	var statusEffect := StatusEffect.new()
	var strength := STRENGTH_STATUS.duplicate()
	strength.stacks = stacksPerTurn
	statusEffect.status = strength
	statusEffect.execute([target])
	
	status_applied.emit(self)
