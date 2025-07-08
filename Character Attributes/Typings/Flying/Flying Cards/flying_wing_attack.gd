extends Card

var baseDamage := 4

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

func increase_crit_chance() -> void:
	Events.increase_crit.emit(2)
