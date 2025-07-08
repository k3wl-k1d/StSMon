extends Relic

var bonusMana := 1

func activate_relic(owner: RelicUI) -> void:
	Events.player_hand_drawn.connect(_add_mana.bind(owner), CONNECT_ONE_SHOT)

func _add_mana(owner: RelicUI) -> void:
	owner.flash()
	var player := PokemonTeam.active as Player
	
	if player:
		player.stats.mana += bonusMana
