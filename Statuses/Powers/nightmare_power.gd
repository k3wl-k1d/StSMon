class_name NightmarePower
extends Status

const CURSE_STATUS := preload("res://Statuses/curse.tres")

var stacksPerTurn := 2

func apply_status(target: Node) -> void:
	var statusEffect := StatusEffect.new()
	var curse := CURSE_STATUS.duplicate()
	curse.stacks = stacksPerTurn
	statusEffect.status = curse
	statusEffect.execute(target.get_tree().get_nodes_in_group("enemies"))
	
	status_applied.emit(self)
