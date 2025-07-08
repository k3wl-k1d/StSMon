class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 70
const BASE_CARD_REWARDS := 3
const BASE_COMMON_WEIGHT := 6.0
const BASE_RARE_WEIGHT := 3.7
const BASE_MYTHICAL_WEIGHT := 0.3

@export var gold := STARTING_GOLD: set = set_gold
@export var cardRewards := BASE_CARD_REWARDS
@export_range(0.0, 10.0) var commonWeight:= BASE_COMMON_WEIGHT
@export_range(0.0, 10.0) var rareWeight := BASE_RARE_WEIGHT
@export_range(0.0, 10.0) var mythicalWeight := BASE_MYTHICAL_WEIGHT

func set_gold(value: int) -> void:
	gold = value
	gold_changed.emit()

func reset_weights() -> void:
	commonWeight = BASE_COMMON_WEIGHT
	rareWeight = BASE_RARE_WEIGHT
	mythicalWeight = BASE_MYTHICAL_WEIGHT
