extends Card

const HASTE_STATUS := preload("res://Statuses/haste.tres")

var baseBlock := 8

func get_default_tooltip() -> String:
	return tooltip % baseBlock

func get_updated_tooltip(playerModifiers: ModifierHandler, enemyModifiers: ModifierHandler) -> String:
	return tooltip % baseBlock

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var blockEffect := BlockEffect.new()
	var statusEffect := StatusEffect.new()
	var haste := HASTE_STATUS.duplicate()
	haste.stacks = 1
	statusEffect.status = haste
	statusEffect.execute([PokemonTeam.active])
	
	var drawEffect := CardDrawEffect.new()
	drawEffect.cardsToDraw = 1
	drawEffect.execute(targets)
	
	blockEffect.amount = baseBlock
	blockEffect.sound = sound
	blockEffect.execute(targets)
