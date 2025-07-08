extends Relic

var block := 3

func activate_relic(owner: RelicUI) -> void:
	var player := PokemonTeam.active
	var blockEffect := BlockEffect.new()
	blockEffect.amount = block
	blockEffect.execute([player])
	owner.flash()
