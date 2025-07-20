extends Relic

@export var attacksRequired := 4

var relicUI: RelicUI
var attacksTotal: int = 0


func initialize_relic(owner: RelicUI) -> void:
	relicUI = owner
	Events.card_played.connect(_on_card_played)


func deactivate_relic(_owner: RelicUI) -> void:
	Events.card_played.disconnect(_on_card_played)



func _on_card_played(card: Card) -> void:
	if card.type != Card.Type.ATTACK:
		return
	
	attacksTotal += 1
	relicUI.relic.currentStacks = floori(attacksTotal / attacksRequired)
	relicUI.update_relic_ui()
	
	if attacksTotal % attacksRequired == 0:
		Events.increase_crit.emit(1)
		relicUI.relic.currentStacks = 0
		relicUI.update_relic_ui()
		relicUI.flash()
