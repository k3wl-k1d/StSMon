class_name EntityHandler
extends Node2D

@onready var playerHandler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemyHandler: EnemyHandler = $EnemyHandler as EnemyHandler

var speedOrder: Array[int] = []
var actionValueOrder = {}
var currentEntity: Entity

func _ready() -> void:
	Events.enemy_fainted.connect(func(entity): 
		check_if_fainted_early(entity)
		remove_entity(entity))
	Events.player_died.connect(func(player): 
		check_if_fainted_early(player)
		remove_entity(player))
	Events.player_revived.connect(func(player): add_entity(player))

func set_turn_order() -> void:
	var entities := playerHandler.get_children()
	entities.append_array(enemyHandler.get_children())
	
	for entity: Entity in entities:
		var speed = get_action_value(entity.get_speed())
		speedOrder.append(speed)
		
		actionValueOrder[entity] = speed
	print("Action order: ")
	print(actionValueOrder)
	speedOrder.sort()

func choose_turn() -> Node2D:
	if speedOrder.size() <= 0 or actionValueOrder.size() <= 0:
		print("Error: Speed Dict and Array are empty")
		return
	speedOrder.sort()
	
	var actionValue = speedOrder[0]
	currentEntity = actionValueOrder.find_key(actionValue)
	for entity in actionValueOrder:
		if entity != currentEntity:
			actionValueOrder[entity] -= actionValue
		else:
			actionValueOrder[entity] = get_action_value(entity.get_speed())
	speedOrder.clear()
	speedOrder.append_array(actionValueOrder.values())
	speedOrder.sort()
	return currentEntity

func check_if_fainted_early(entity: Entity) -> void:
	if entity == currentEntity:
		Events.entity_fainted_early.emit()

func remove_entity(entity: Entity) -> void:
	if entity:
		speedOrder.erase(actionValueOrder[entity])
		speedOrder.sort()
		actionValueOrder.erase(entity)
		print("Removed entity: ", entity)

func add_entity(entity: Entity) -> void:
	var speed := get_action_value(entity.get_speed())
	speedOrder.append(speed)
	speedOrder.sort()
	actionValueOrder[entity] = speed
	print("Added entity: ", entity)

func settle_speed_tie(group: Array[Area2D]) -> void:
	pass

func get_turn_order() -> Array[Entity]:
	var turnArray: Array[Entity]
	var actionValues = actionValueOrder.duplicate(true)
	for speed in speedOrder:
		#print(speed)
		#print(actionValues.find_key(speed))
		turnArray.append(actionValues.find_key(speed))
		actionValues.erase(actionValues.find_key(speed))
	return turnArray

func get_action_value(speed: int) -> int:
	return 10000/speed
