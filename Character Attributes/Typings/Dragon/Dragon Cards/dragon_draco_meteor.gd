extends Card

const INTIMIDATION_STATUS := preload("res://Statuses/intimidation.tres")

var baseDamage := 20
var intimDur := 2

func get_default_tooltip() -> String:
	return tooltip % baseDamage

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % modifiedDamage

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var statusEffect := StatusEffect.new()
	var intimidation := INTIMIDATION_STATUS.duplicate()
	intimidation.duration = intimDur
	statusEffect.status = intimidation
	statusEffect.execute([PokemonTeam.active])
	
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
