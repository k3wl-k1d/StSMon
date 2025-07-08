extends Card

const NIGHTMARE_POWER := preload("res://Statuses/Powers/nightmare_power.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var nightmare := NIGHTMARE_POWER.duplicate()
	statusEffect.status = nightmare
	statusEffect.execute(targets)
