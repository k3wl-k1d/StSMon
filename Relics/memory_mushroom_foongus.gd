extends Relic

@export var baseBlock := 2

var relicUI: RelicUI
var blockEffect: BlockEffect
var foongus: Player

func initialize_relic(owner: RelicUI) -> void:
	relicUI = owner
	Events.battle_started.connect(_on_player_stats_ready)

func deactivate_relic(_owner: RelicUI) -> void:
	Events.battle_started.disconnect(_on_player_stats_ready)
	if Events.card_played.is_connected(add_block):
		Events.card_played.disconnect(add_block)

func _on_player_stats_ready() -> void:
	if not Events.card_played.is_connected(add_block):
		Events.card_played.connect(add_block)
	blockEffect = BlockEffect.new()
	blockEffect.amount = baseBlock

func add_block(_card: Card) -> void:
	if not foongus:
		foongus = PokemonTeam.get_player("Foongus")
	relicUI.flash()
	blockEffect.execute([foongus])
	
