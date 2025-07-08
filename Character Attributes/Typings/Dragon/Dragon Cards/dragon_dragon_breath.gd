extends Card

const PARALYSIS_STATUS := preload("res://Statuses/paralysis.tres")
const BURN_STATUS := preload("res://Statuses/burn.tres")

var baseDamage := 5
var statusDuration := 3

func get_default_tooltip() -> String:
	return tooltip % baseDamage

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % modifiedDamage

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
	
	var statusEffect := StatusEffect.new()
	var rng := RNG.instance.randi_range(1,50)
	if rng >= 25:
		var para := PARALYSIS_STATUS.duplicate()
		para.duration = statusDuration
		statusEffect.status = para
	else:
		var burn := BURN_STATUS.duplicate()
		burn.duration = statusDuration
		statusEffect.status = burn
	statusEffect.execute(targets)
