extends Relic

var healAmount := 8

func activate_relic(owner: RelicUI) -> void:
	var p1 := owner.get_tree().get_nodes_in_group("player")[0] as Player
	var p2 := owner.get_tree().get_nodes_in_group("player")[1] as Player
	var used := false
	
	if p1 and p1.stats.health < p1.stats.maxHealth and not PokemonTeam.fainted.has(p1):
		p1.stats.heal(healAmount)
		used = true
	if p2 and p2.stats.health < p2.stats.maxHealth and not PokemonTeam.fainted.has(p2):
		p2.stats.heal(healAmount)
		used = true
	if used:
		owner.flash()
		owner.relic.currentStacks -= 1
