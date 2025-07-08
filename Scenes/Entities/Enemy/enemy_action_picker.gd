class_name EnemyActionPicker
extends Node

@export var enemy: Enemy: set = _set_enemy
@export var target: Node2D: set = _set_target

@onready var totalWeight := 0.0

var requiredTargets: Array[Node2D] = []

func _ready() -> void:
	requiredTargets = []
	Events.spotlight_active.connect(_on_spotlight_active)
	Events.spotlight_deactive.connect(_on_spotlight_deactive)
	set_new_target()
	setup_chances()

func get_action() -> EnemyAction:
	# Return a potential conditional action
	var action := get_first_conditional_action()
	if action:
		return action
	
	return get_chance_based_action()

func get_first_conditional_action() -> EnemyAction:
	var action: EnemyAction
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CONDITIONAL:
			continue
		if action.is_performable():
			return action
	
	return null

func get_chance_based_action() -> EnemyAction:
	var action: EnemyAction
	var roll := RNG.instance.randf_range(0.0, totalWeight)
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CHANCE:
			continue
		if action.accumulatedWeight > roll:
			return action
	
	return null

func setup_chances() -> void:
	var action: EnemyAction
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CHANCE:
			continue
		totalWeight += action.chanceWeight
		action.accumulatedWeight = totalWeight

func set_new_target() -> void:
	var allTargets: Array[Node] = get_tree().get_nodes_in_group("player")
	if requiredTargets.is_empty():
		if PokemonTeam.fainted.size() == 1:
			var fainted := PokemonTeam.fainted
			for player in fainted:
				if allTargets.has(player):
					allTargets.erase(player)
		target = RNG.array_pick_random(allTargets)
	else:
		target = RNG.array_pick_random(requiredTargets)

func _set_enemy(value: Enemy) -> void:
	enemy = value
	
	for action in get_children():
		action.enemy = enemy

func _set_target(value: Node2D) -> void:
	target = value
	for action in get_children():
		action.target = target

func _on_spotlight_active(spotlightTarget: Node2D) -> void:
	print("SPOTLIGHT ACTIVE    ", spotlightTarget)
	requiredTargets.append(spotlightTarget)
	set_new_target()

func _on_spotlight_deactive(spotlightTarget: Node2D) -> void:
	print("SPOTLIGHT DEACTIVE    ", spotlightTarget)
	requiredTargets.erase(spotlightTarget)
