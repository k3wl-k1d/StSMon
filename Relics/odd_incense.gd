extends Relic

var relicUI: RelicUI
#TODO Maybe make it so whenever you draw in general randomize costs

func initialize_relic(owner: RelicUI) -> void:
	relicUI = owner
	Events.player_hand_drawn.connect(_on_player_hand_drawn)


func deactivate_relic(_owner: RelicUI) -> void:
	Events.player_hand_drawn.disconnect(_on_player_hand_drawn)


func _on_player_hand_drawn() -> void:
	relicUI.flash()
	var playerHandler := relicUI.get_tree().get_first_node_in_group("player_handler") as PlayerHandler
	
	for cardUI: CardUI in playerHandler.hand.get_children():
		cardUI.card.cost = RNG.instance.randi_range(0, 3)
		cardUI.card = cardUI.card
