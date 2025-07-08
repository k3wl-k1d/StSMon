extends Card

var damage := 10
var block := 12

func get_default_tooltip() -> String:
	return tooltip % block

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	return tooltip % block

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var blockEffect := BlockEffect.new()
	targets[0].take_damage(damage, Modifier.Type.NO_MODIFIER)
	
	blockEffect.amount = block
	blockEffect.sound = sound
	blockEffect.execute([PokemonTeam.active])
