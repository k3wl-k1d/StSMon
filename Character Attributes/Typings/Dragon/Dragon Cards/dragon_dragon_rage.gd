extends Card

var baseDamage := 4
var extraDamage := 6

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, extraDamage]

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modifiedDamage := player_modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modifiedDamage = enemy_modifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
		
	return tooltip % [modifiedDamage, extraDamage]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	damageEffect.amount = modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
	baseDamage += extraDamage
