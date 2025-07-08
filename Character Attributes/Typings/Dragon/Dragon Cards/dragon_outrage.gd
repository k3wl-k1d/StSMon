extends Card

var baseDamage := 14
var extraDamage := 6

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, extraDamage]

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [modifiedDamage, extraDamage]

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
	baseDamage += extraDamage
	
	var exhaustRandom := ExhaustRandomEffect.new()
	exhaustRandom.amount = 2
	exhaustRandom.execute(targets)
