class_name BattleStatsPool
extends Resource

@export var pool: Array[BattleStats]

var totalWeightsByTier := [0.0,0.0,0.0]

func _get_all_battles_by_tier(tier: int) -> Array[BattleStats]:
	return pool.filter(
		func(battle: BattleStats):
			return battle.battleTier == tier
	)

func _setup_weight_for_tier(tier: int) -> void:
	var battles := _get_all_battles_by_tier(tier)
	totalWeightsByTier[tier] = 0
	
	for battle: BattleStats in battles:
		totalWeightsByTier[tier] += battle.weight
		battle.accumulatedWeight = totalWeightsByTier[tier]

func get_random_battle_for_tier(tier: int) -> BattleStats:
	var roll := randf_range(0.0, totalWeightsByTier[tier])
	var battles := _get_all_battles_by_tier(tier)
	
	for battle: BattleStats in battles:
		if battle.accumulatedWeight > roll:
			return battle
	
	return null

func setup() -> void:
	for i in 3:
		_setup_weight_for_tier(i)
