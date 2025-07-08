extends Card

func get_default_tooltip() -> String:
	return tooltip

func get_updated_tooltip(_playerModifiers: ModifierHandler, _enemyModifiers: ModifierHandler) -> String:
	return tooltip

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var drawEffect := CardDrawEffect.new()
	drawEffect.cardsToDraw = 1
	drawEffect.execute(targets)
	SFXPlayer.play(sound)

func increase_crit_chance() -> void:
	Events.increase_crit.emit(3)
