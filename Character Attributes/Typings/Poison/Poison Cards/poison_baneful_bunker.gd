extends Card

var baseBlock := 7

func get_default_tooltip() -> String:
	return tooltip % baseBlock

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	return tooltip % baseBlock

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var blockEffect := BlockEffect.new()
	blockEffect.amount = baseBlock
	blockEffect.execute([PokemonTeam.active])
	
	blockEffect.amount = targets[0].stats.block
	blockEffect.sound = sound
	blockEffect.execute([PokemonTeam.active])
