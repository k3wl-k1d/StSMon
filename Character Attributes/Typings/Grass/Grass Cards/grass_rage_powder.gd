extends Card

const SPOTLIGHT_STATUS := preload("res://Statuses/spotlight.tres")

var spotlightDuration := 1
var baseBlock := 6

func get_default_tooltip() -> String:
	return tooltip % baseBlock

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	return tooltip % baseBlock

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var blockEffect := BlockEffect.new()
	var spotlight := SPOTLIGHT_STATUS.duplicate()
	
	blockEffect.amount = baseBlock
	blockEffect.sound = sound
	blockEffect.execute(targets)
	
	spotlight.duration = spotlightDuration
	statusEffect.status = spotlight
	statusEffect.execute(targets)
