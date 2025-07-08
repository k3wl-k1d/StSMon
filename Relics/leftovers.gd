extends Relic

var healing := 1

func activate_relic(owner: RelicUI) -> void:
	var player := PokemonTeam.active
	if player and player.stats.health < player.stats.maxHealth:
		player.stats.heal(healing)
		owner.flash()
