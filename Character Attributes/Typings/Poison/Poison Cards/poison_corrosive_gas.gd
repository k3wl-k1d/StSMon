extends Card

var blockRemoveThreshold := 6
var counter := 0

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	for cardTarget: Node in targets:
		counter += cardTarget.stats.block
		cardTarget.stats.block = 0
	var cardDraw := CardDrawEffect.new()
	var cardsToDraw := floori(counter / blockRemoveThreshold)
	if cardsToDraw > 0:
		cardDraw.cardsToDraw = cardsToDraw
		cardDraw.execute([PokemonTeam.active])
	SFXPlayer.play(sound)
