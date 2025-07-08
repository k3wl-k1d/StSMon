class_name CardDrawEffect
extends Effect

var cardsToDraw := 1

func execute(targets: Array[Node]) -> void:
	if targets.is_empty():
		return
		
	var playHandler := targets[0].get_tree().get_first_node_in_group("player_handler") as PlayerHandler
	
	if not playHandler:
		return
	
	playHandler.draw_cards(cardsToDraw)
