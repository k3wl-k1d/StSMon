extends Card

const TOXIC_THREAD_POWER := preload("res://Statuses/Powers/toxic_thread_power.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var toxicThread := TOXIC_THREAD_POWER.duplicate()
	statusEffect.status = toxicThread
	statusEffect.execute(targets)
