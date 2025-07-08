class_name Map
extends Node2D

const SCROLL_SPEED := 25
const MAP_ROOM := preload("res://Scenes/Map/map_room.tscn")
const MAP_LINE := preload("res://Scenes/Map/map_line.tscn")

@onready var mapGenerator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var visuals: Node2D = $Visuals
@onready var camera: Camera2D = $Camera2D

var mapData: Array[Array]
var floorsClimbed: int
var lastRoom: Room
var camEdgeY: float

func _ready() -> void:
	camEdgeY = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("scroll_up"):
		camera.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera.position.y += SCROLL_SPEED
	
	camera.position.y = clamp(camera.position.y, -camEdgeY, 0)

func generate_new_map() -> void:
	floorsClimbed = 0
	mapData = mapGenerator.generate_map()
	create_map()

func load_map(map: Array[Array], floorsCompleted: int, lastRoomClimbed: Room) -> void:
	floorsClimbed = floorsCompleted
	mapData = map
	lastRoom = lastRoomClimbed
	create_map()
	
	if floorsClimbed > 0:
		unlock_next_rooms()
	else:
		unlock_floor()

func create_map() -> void:
	for currentFloor: Array in mapData:
		for room: Room in currentFloor:
			if room.nextRooms.size() > 0:
				_spawn_room(room)
	
	# Boss room has no next room but must be spawned
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(mapData[MapGenerator.FLOORS-1][middle])
	
	var mapWidthPixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH-1)
	visuals.position.x = (get_viewport_rect().size.x - mapWidthPixels)/2
	visuals.position.y = get_viewport_rect().size.y/2

func unlock_floor(floorNum: int = floorsClimbed) -> void:
	for mapRoom: MapRoom in rooms.get_children():
		if mapRoom.room.row == floorNum:
			mapRoom.available = true

func unlock_next_rooms() -> void:
	for mapRoom: MapRoom in rooms.get_children():
		if lastRoom.nextRooms.has(mapRoom.room):
			mapRoom.available = true

func show_map() -> void:
	show()
	camera.enabled = true

func hide_map() -> void:
	hide()
	camera.enabled = false

func _spawn_room(room: Room) -> void:
	var newMapRoom := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(newMapRoom)
	newMapRoom.room = room
	newMapRoom.selected_room.connect(_on_map_room_selected)
	newMapRoom.clicked.connect(_on_map_room_clicked)
	_connect_lines(room)
	
	if room.selected and room.row < floorsClimbed:
		newMapRoom.show_selected()

func _connect_lines(room: Room) -> void:
	if room.nextRooms.is_empty():
		return
	
	for nextRoom: Room in room.nextRooms:
		var newMapLine := MAP_LINE.instantiate() as Line2D
		newMapLine.add_point(room.position)
		newMapLine.add_point(nextRoom.position)
		lines.add_child(newMapLine)

func _on_map_room_selected(room: Room) -> void:
	lastRoom = room
	floorsClimbed += 1
	Events.map_exited.emit(room)

func _on_map_room_clicked(room: Room) -> void:
	for mapRoom: MapRoom in rooms.get_children():
		if mapRoom.room.row == room.row:
			mapRoom.available = false
