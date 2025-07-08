class_name EventRoomPool
extends Resource

@export var eventRooms: Array[PackedScene]

func get_random() -> PackedScene:
	return eventRooms.pick_random()
