extends Card

var enemyDamage := 11
var allyDamage := 5

func get_default_tooltip() -> String:
	return tooltip % enemyDamage

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	var modifiedDamage := playerModifiers.get_modified_value(enemyDamage, Modifier.Type.DMG_DEALT)
	
	if enemyModifiers:
		modifiedDamage = enemyModifiers.get_modified_value(modifiedDamage, Modifier.Type.DMG_TAKEN)
	
	return tooltip % modifiedDamage

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var damageEffect := DamageEffect.new()
	var ally := PokemonTeam.players
	ally.erase(PokemonTeam.active)
	
	if ally[0]:
		ally[0].take_damage(allyDamage, Modifier.Type.NO_MODIFIER)
	
	damageEffect.amount = _modifiers.get_modified_value(enemyDamage, Modifier.Type.DMG_DEALT)
	damageEffect.sound = sound
	damageEffect.execute(targets)
