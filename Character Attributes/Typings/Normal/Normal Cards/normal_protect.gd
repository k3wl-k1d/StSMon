extends Card

var baseBlock := 5

func get_default_tooltip() -> String:
	return tooltip % baseBlock

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	return tooltip % baseBlock

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var blockEffect := BlockEffect.new()
	blockEffect.amount = baseBlock
	blockEffect.sound = sound
	blockEffect.execute(targets)
