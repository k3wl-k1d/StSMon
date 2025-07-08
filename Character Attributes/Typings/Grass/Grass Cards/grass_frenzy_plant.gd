extends Card

const SLEEP_STATUS := preload("res://Statuses/sleep.tres")

var baseDamage := 20
var sleepTurns := 2

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, sleepTurns]

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [modifiedDamage, sleepTurns]

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var statusEffect := StatusEffect.new()
	var sleep := SLEEP_STATUS.duplicate()
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	sleep.duration = sleepTurns
	statusEffect.status = sleep
	damageEffect.execute(targets)
	statusEffect.execute([PokemonTeam.active])
