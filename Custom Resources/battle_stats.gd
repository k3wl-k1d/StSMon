class_name BattleStats
extends Resource

@export_range(0,2) var battleTier: int
@export_range(0.0, 10.0) var weight: float
@export var goldMin: int
@export var goldMax: int
@export var enemies: PackedScene

var accumulatedWeight: float = 0.0

func roll_gold_reward() -> int:
	return RNG.instance.randi_range(goldMin, goldMax)
