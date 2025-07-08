class_name MapGenerator
extends Node

const X_DIST := 80
const Y_DIST := 70
const PLACEMENT_RANDOMNESS := 7
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 12.0
const EVENT_ROOM_WEIGHT := 5.0
const SHOP_ROOM_WEIGHT := 2.5
const POKECENTER_ROOM_WEIGHT := 4.0

@export var battleStatsPool: BattleStatsPool
@export var eventRoomPool: EventRoomPool

var randomRoomTypeWeights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.POKECENTER: 0.0,
	Room.Type.EVENT: 0.0
}
var randomRoomTypeTotalWeight := 0.0
var mapData: Array[Array]

func generate_map() -> Array[Array]:
	mapData = _generate_initial_grid()
	var startingPoints := _get_random_starting_points()
	
	for j in startingPoints:
		var currentj := j
		for i in FLOORS-1:
			currentj = _setup_connection(i, currentj)
	
	battleStatsPool.setup()
	
	_setup_boss_room()
	_setup_room_weights()
	_setup_room_types()
	
	# Prints map to screen
	#var i := 0
	#for mapFLoor in mapData:
		#print("floor %s" % i)
		#var usedRooms = mapFLoor.filter(
			#func(room: Room): return room.nextRooms.size() > 0
		#)
		#print(usedRooms)
		#i+=1
	
	return mapData

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacentRooms: Array[Room] = []
		
		for j in MAP_WIDTH:
			var currentRoom := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			currentRoom.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			currentRoom.row = i
			currentRoom.column = j
			currentRoom.nextRooms = []
			
			# Boss room has a non-random Y
			if i == FLOORS - 1:
				currentRoom.position.y = (i+1) * -Y_DIST
			
			adjacentRooms.append(currentRoom)
			
		result.append(adjacentRooms)
	
	return result

func _get_random_starting_points() -> Array[int]:
	var yCoords: Array[int]
	var uniquePoints: int = 0
	
	while uniquePoints < 2:
		uniquePoints = 0
		yCoords = []
		
		for i in PATHS:
			var startingPoint := randi_range(0, MAP_WIDTH - 1)
			if not yCoords.has(startingPoint):
				uniquePoints += 1
			
			yCoords.append(startingPoint)
	
	return yCoords

func _setup_connection(i: int, j: int) -> int:
	var nextRoom: Room
	var currentRoom := mapData[i][j] as Room
	
	@warning_ignore("unassigned_variable")
	while not nextRoom or _would_cross_existing_path(i, j, nextRoom):
		var randomj := clampi(randi_range(j-1, j+1), 0, MAP_WIDTH-1)
		nextRoom = mapData[i+1][randomj]
	currentRoom.nextRooms.append(nextRoom)
	
	return nextRoom.column

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var leftNeighbor: Room
	var rightNeighbor: Room
	
	# if j == 0, there is no left neighbor
	if j > 0:
		leftNeighbor = mapData[i][j-1]
	# if j == MAP_WIDTH - 1, there is no right neighbor
	if j < MAP_WIDTH - 1:
		rightNeighbor = mapData[i][j+1]
	
	# Can't cross in right dir if right neighbor goes left
	if rightNeighbor and room.column > j:
		for nextRoom: Room in rightNeighbor.nextRooms:
			if nextRoom.column < room.column:
				return true
	
	# Can't cross in left dir if left neighbor goes right
	if leftNeighbor and room.column < j:
		for nextRoom: Room in leftNeighbor.nextRooms:
			if nextRoom.column > room.column:
				return true
	
	return false

func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var bossRoom := mapData[FLOORS - 1][middle] as Room
	
	for j in MAP_WIDTH:
		var currentRoom = mapData[FLOORS - 2][j] as Room
		if currentRoom.nextRooms:
			currentRoom.nextRooms = [] as Array[Room]
			currentRoom.nextRooms.append(bossRoom)
	
	bossRoom.type = Room.Type.BOSS
	bossRoom.battleStats = battleStatsPool.get_random_battle_for_tier(2)

func _setup_room_weights() -> void:
	randomRoomTypeWeights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	randomRoomTypeWeights[Room.Type.SHOP] = MONSTER_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	randomRoomTypeWeights[Room.Type.POKECENTER] = MONSTER_ROOM_WEIGHT + SHOP_ROOM_WEIGHT + POKECENTER_ROOM_WEIGHT
	randomRoomTypeWeights[Room.Type.EVENT] = randomRoomTypeWeights[Room.Type.POKECENTER] + EVENT_ROOM_WEIGHT
	
	randomRoomTypeTotalWeight = randomRoomTypeWeights[Room.Type.EVENT]

func _setup_room_types() -> void:
	# First floor is always a battle
	for room: Room in mapData[0]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.MONSTER
			room.battleStats = battleStatsPool.get_random_battle_for_tier(0)
	
	# 9th floor is always treasure
	for room: Room in mapData[floori(FLOORS * 0.5)+1]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.TREASURE
	
	# Last floor before boss is always a campfire
	for room: Room in mapData[FLOORS - 2]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.POKECENTER
	
	# Rest of rooms
	for currentFloor in mapData:
		for room: Room in currentFloor:
			for nextRoom: Room in room.nextRooms:
				if nextRoom.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(nextRoom)

func _set_room_randomly(roomToSet: Room) -> void:
	var healsBefore4 := true
	var consecutiveHeals := true
	var consecutiveShop := true
	var healsOn13 := true
	
	var typeCandidate: Room.Type
	
	while healsBefore4 or consecutiveHeals or consecutiveShop or healsOn13:
		typeCandidate = _get_random_room_type_by_weight()
		
		var isHeals := typeCandidate == Room.Type.POKECENTER
		var hasPokecenterParent := _room_has_parent_of_type(roomToSet, Room.Type.POKECENTER)
		var isShop := typeCandidate == Room.Type.SHOP
		var hasShopParent := _room_has_parent_of_type(roomToSet, Room.Type.SHOP)
		
		healsBefore4 = isHeals and roomToSet.row < 3
		consecutiveHeals = isHeals and hasPokecenterParent
		consecutiveShop = isShop and hasShopParent
		healsOn13 = isHeals and roomToSet.row == 12
	
	roomToSet.type = typeCandidate
	
	if typeCandidate == Room.Type.MONSTER:
		var tier := 0
		
		if roomToSet.row > 2:
			tier = 1
		
		roomToSet.battleStats = battleStatsPool.get_random_battle_for_tier(tier)
	
	if typeCandidate == Room.Type.EVENT:
		roomToSet.eventScene = eventRoomPool.get_random()

func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	# Left parent
	if room.column > 0 and room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column - 1] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	# Below parent
	if room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	# Right parent
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column + 1] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	return false

func _get_random_room_type_by_weight() -> Room.Type:
	var roll = randf_range(0.0, randomRoomTypeTotalWeight)
	
	for type: Room.Type in randomRoomTypeWeights:
		if randomRoomTypeWeights[type] > roll:
			return type
	
	return Room.Type.MONSTER
