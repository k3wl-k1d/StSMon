extends Card

const SPOTLIGHT_STATUS := preload("res://Statuses/spotlight.tres")

var spotlightDuration := 1

func get_default_tooltip() -> String:
	return tooltip

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var spotlight := SPOTLIGHT_STATUS.duplicate()
	spotlight.duration = spotlightDuration
	statusEffect.status = spotlight
	statusEffect.execute(targets)
