class_name SleepStatus
extends Status

func apply_status(target: Node) -> void:
	Events.skip_current_turn.emit(target)
	
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip % duration
