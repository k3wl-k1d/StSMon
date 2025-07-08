extends Relic

var relicUI: RelicUI

func initialize_relic(owner: RelicUI) -> void:
	relicUI = owner
	Events.battle_won.connect(_on_battle_won)

func deactivate_relic(_owner: RelicUI) -> void:
	Events.battle_won.disconnect(_on_battle_won)

func _on_battle_won() -> void:
	relicUI.flash()
