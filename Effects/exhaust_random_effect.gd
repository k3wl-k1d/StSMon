class_name ExhaustRandomEffect
extends Effect

var amount := 1

func execute(targets: Array[Node]) -> void:
	if targets.is_empty():
		return
		
	var playerHandler := targets[0].get_tree().get_first_node_in_group("player_handler") as PlayerHandler
	
	if not playerHandler:
		return
	
	var handRandomized := playerHandler.hand.get_children().duplicate()
	RNG.array_shuffle(handRandomized)
	var cards := handRandomized.slice(0, amount)
	
	for card in cards:
		card.queue_free()
