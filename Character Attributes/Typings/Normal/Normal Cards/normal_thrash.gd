extends Card

var baseDamage := 6
var extraDamage := 4

func get_default_tooltip() -> String:
	return tooltip % [baseDamage, extraDamage]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modifiedDamage := player_modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modifiedDamage = enemy_modifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [modifiedDamage, extraDamage]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	baseDamage += extraDamage
