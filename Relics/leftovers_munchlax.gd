extends Relic

var munchlaxHealing := 4

func activate_relic(owner: RelicUI) -> void:
	var player := PokemonTeam.active
	if player and player.stats.name == "Munchlax" and player.stats.health < player.stats.maxHealth:
		PokemonTeam.active.stats.heal(munchlaxHealing)
		owner.flash()
