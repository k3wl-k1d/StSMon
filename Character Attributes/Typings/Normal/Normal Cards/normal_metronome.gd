extends Card

const ALL_CARDS := preload("res://Character Attributes/metronome_cards.tres")

func get_default_tooltip() -> String:
	return tooltip

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var allCards := ALL_CARDS.duplicate()
