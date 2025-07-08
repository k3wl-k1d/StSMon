extends Relic

@export var baseBlock := 1

var relicUI: RelicUI
var blockEffect : BlockEffect

func initialize_relic(owner: RelicUI) -> void:
	Events.card_played.connect(add_block)
	blockEffect = BlockEffect.new()
	blockEffect.amount = baseBlock
	relicUI = owner

func deactivate_relic(_owner: RelicUI) -> void:
	if Events.card_played.is_connected(add_block):
		Events.card_played.disconnect(add_block)

func add_block(_card: Card) -> void:
	relicUI.flash()
	blockEffect.execute([PokemonTeam.active])
	
