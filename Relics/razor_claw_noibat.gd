extends Relic

@export var attacksRequired := 3

var relicUI: RelicUI
var attacksTotal: int = 0

func initialize_relic(owner: RelicUI) -> void:
	relicUI = owner
	Events.card_played.connect(_on_card_played)

func deactivate_relic(_owner: RelicUI) -> void:
	Events.card_played.disconnect(_on_card_played)

func _on_card_played(_card: Card) -> void:
	attacksTotal += 1
	relicUI.relic.currentStacks = attacksTotal
	relicUI.update_relic_ui()
	
	if attacksTotal % attacksRequired == 0:
		Events.increase_crit.emit(1)
		relicUI.relic.currentStacks = 0
		relicUI.update_relic_ui()
		relicUI.flash()
