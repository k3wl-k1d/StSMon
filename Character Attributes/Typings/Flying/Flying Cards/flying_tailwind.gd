extends Card

const RUSH_STATUS := preload("res://Statuses/rush.tres")

var rushDuration := 3

func get_default_tooltip() -> String:
	return tooltip % rushDuration

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip % rushDuration

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var drawEffect := CardDrawEffect.new()
	var rush := RUSH_STATUS.duplicate()
	
	rush.duration = rushDuration
	statusEffect.status = rush
	statusEffect.execute(targets)
	
	drawEffect.cardsToDraw = 1
	drawEffect.execute(targets)
	
	SFXPlayer.play(sound)
