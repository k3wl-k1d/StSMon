class_name ToxicThreadPower
extends Status

const POISON_STATUS := preload("res://Statuses/poison.tres")

var stacksPerTurn := 4

func apply_status(target: Node) -> void:
	var statusEffect := StatusEffect.new()
	var poison := POISON_STATUS.duplicate()
	poison.stacks = stacksPerTurn
	statusEffect.status = poison
	statusEffect.execute(target.get_tree().get_nodes_in_group("enemies"))
	
	status_applied.emit(self)
