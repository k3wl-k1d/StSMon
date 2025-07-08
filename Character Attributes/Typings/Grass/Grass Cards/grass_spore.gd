extends Card

const SLEEP_STATUS := preload("res://Statuses/sleep.tres")

var sleepTurns := 1

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var sleep := SLEEP_STATUS.duplicate()
	sleep.duration = sleepTurns
	statusEffect.status = sleep
	statusEffect.execute(targets)
