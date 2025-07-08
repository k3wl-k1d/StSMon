class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, POKECENTER, SHOP, EVENT, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var nextRooms: Array[Room]
@export var selected := false

# This is only used by MONSTER and BOSS types
@export var battleStats: BattleStats

# This is only used by EVENT types
@export var eventScene: PackedScene

func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
