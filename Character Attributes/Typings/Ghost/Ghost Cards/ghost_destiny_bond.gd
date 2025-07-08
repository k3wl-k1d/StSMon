extends Card

const CURSE_STATUS := preload("res://Statuses/curse.tres")

var curseAmount := 5

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	if PokemonTeam.fainted.is_empty():
		var active := PokemonTeam.active.stats
		var healing := active.maxHealth - active.health
		var statusEffect := StatusEffect.new()
		var curse := CURSE_STATUS.duplicate()
		curse.stacks = curseAmount
		statusEffect.status = curse
		statusEffect.execute([PokemonTeam.active])
		active.heal(healing)
		active.block += healing
		targets[0].kill_entity()
