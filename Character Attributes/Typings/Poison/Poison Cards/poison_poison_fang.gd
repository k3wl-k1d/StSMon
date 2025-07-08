extends Card

const POISON_STATUS := preload("res://Statuses/poison.tres")

var baseDamage := 3
var poisonStacks := 3

func get_default_tooltip() -> String:
	return tooltip % [poisonStacks, baseDamage]

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % [poisonStacks, modifiedDamage]

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var poison := POISON_STATUS.duplicate()
	poison.stacks = poisonStacks
	statusEffect.status = poison
	statusEffect.execute(targets)
	
	var damageEffect := DamageEffect.new()
	damageEffect.amount = _modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
