extends Card

const RUSH_STATUS := preload("res://Statuses/rush.tres")

var baseDamage := 9
var rushDuration := 3

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, rushDuration]

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [modifiedDamage, rushDuration]

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var statusEffect := StatusEffect.new()
	var rush := RUSH_STATUS.duplicate()
	rush.duration = rushDuration
	statusEffect.status = rush
	statusEffect.execute(PokemonTeam.players)
	
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
