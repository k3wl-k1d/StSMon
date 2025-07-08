extends Card

const SLEEP_STATUS := preload("res://Statuses/sleep.tres")

var sleepTurns := 3

func get_default_tooltip() -> String:
	return tooltip % sleepTurns

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip % sleepTurns

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var sleep := SLEEP_STATUS.duplicate()
	sleep.duration = sleepTurns
	statusEffect.status = sleep
	statusEffect.execute(targets)
