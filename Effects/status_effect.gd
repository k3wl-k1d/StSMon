class_name StatusEffect
extends Effect

var status: Status

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			var newStatus: Status = status.duplicate(true)
			target.statusHandler.add_status(newStatus)
