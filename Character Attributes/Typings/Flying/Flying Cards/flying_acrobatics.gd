extends Card

const HASTE_STATUS := preload("res://Statuses/haste.tres")

var baseDamage := 2
var hasteStacks := 1

func get_default_tooltip() -> String:
	return tooltip % baseDamage

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % modifiedDamage

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var statusEffect := StatusEffect.new()
	var haste := HASTE_STATUS.duplicate()
	haste.stacks = hasteStacks
	statusEffect.status = haste
	statusEffect.execute([PokemonTeam.active])
	
	var drawEffect := CardDrawEffect.new()
	drawEffect.cardsToDraw = 1
	drawEffect.execute(targets)
	
	damageEffect.amount = modifiers.get_modified_value(baseDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
