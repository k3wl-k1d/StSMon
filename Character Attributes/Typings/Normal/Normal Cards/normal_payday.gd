extends Card

var baseDamage := 8

func get_default_tooltip() -> String:
	return tooltip % baseDamage

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % modifiedDamage

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var getBonusGold := false
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	getBonusGold = targets[0].get_health_after_damage(baseDamage, Modifier.Type.DMG_DEALT) <= 0
	damageEffect.execute(targets)
	if getBonusGold:
		var run := targets[0].get_tree().get_first_node_in_group("run") as Run
		run.stats.gold += 10
