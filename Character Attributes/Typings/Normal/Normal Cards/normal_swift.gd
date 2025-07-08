extends Card

var baseBlock := 2

func get_default_tooltip() -> String:
	return tooltip % baseBlock


func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip % baseBlock


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var blockEffect := BlockEffect.new()
	blockEffect.amount = baseBlock
	blockEffect.sound = sound
	blockEffect.execute(targets)

	var cardDrawEffect := CardDrawEffect.new()
	cardDrawEffect.cardsToDraw = 1
	cardDrawEffect.execute(targets)
