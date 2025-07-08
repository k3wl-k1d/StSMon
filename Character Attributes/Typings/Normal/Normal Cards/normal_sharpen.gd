extends Card

const SHARPEN_POWER := preload("res://Statuses/Powers/sharpen_power.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var sharpen := SHARPEN_POWER.duplicate()
	statusEffect.status = sharpen
	statusEffect.execute(targets)
