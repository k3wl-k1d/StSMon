extends Card

const STRENGtH_STATUS := preload("res://Statuses/strength.tres")
const HASTE_STATUS := preload("res://Statuses/haste.tres")

func get_default_tooltip() -> String:
	return tooltip

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var strength := STRENGtH_STATUS.duplicate()
	var haste := HASTE_STATUS.duplicate()
	strength.stacks = 1
	haste.stacks = 1
	statusEffect.status = strength
	statusEffect.execute(targets)
	statusEffect.status = haste
	statusEffect.execute(targets)
	SFXPlayer.play(sound)
