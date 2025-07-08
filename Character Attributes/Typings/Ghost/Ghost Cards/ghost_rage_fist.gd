extends Card

var baseDamage := 5
var boostedDamage := baseDamage + 20

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, boostedDamage]

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedBaseDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	var modifiedBoostedDamage := playerModifiers.get_modified_value(boostedDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedBaseDamage = enemyModifiers.get_modified_value(modifiedBaseDamage, Modifier.Type.DMG_TAKEN)
		modifiedBoostedDamage = enemyModifiers.get_modified_value(modifiedBoostedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [modifiedBaseDamage, modifiedBoostedDamage]

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	if PokemonTeam.fainted.is_empty():
		damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	else:
		damageEffect.amount = _modifiers.get_modified_value(boostedDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
