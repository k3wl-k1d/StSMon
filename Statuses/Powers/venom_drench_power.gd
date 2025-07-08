class_name VenomDrenchPower
extends Status

var poisonAmount := 6

func initialize_status(target: Node) -> void:
	if not target is Entity:
		return
	if target.statusHandler._has_status("poison"):
		target.statusHandler._get_status("poison").percentIncrease = 1
