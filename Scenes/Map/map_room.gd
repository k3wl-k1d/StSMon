class_name MapRoom
extends Area2D

signal clicked(room: Room)
signal selected_room(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED : [null, Vector2.ONE],
	Room.Type.MONSTER : [preload("res://art/tile_0103.png"), Vector2(2,2)],
	Room.Type.TREASURE : [preload("res://art/tile_0089.png"), Vector2(2,2)],
	Room.Type.POKECENTER : [preload("res://art/player_heart.png"), Vector2(1.2, 1.2)],
	Room.Type.SHOP : [preload("res://art/gold.png"), Vector2(1.2, 1.2)],
	Room.Type.BOSS : [preload("res://art/tile_0105.png"), Vector2(2.5, 2.5)],
	Room.Type.EVENT: [preload("res://art/rarity.png"), Vector2(1.8, 1.8)]
}

@onready var sprite: Sprite2D = $Visuals/Sprite2D
@onready var line: Line2D = $Visuals/Line2D
@onready var animation: AnimationPlayer = $AnimationPlayer

var available := false: set = set_available
var room: Room: set = set_room

func set_available(value: bool) -> void:
	available = value
	
	if available:
		animation.play("highlight")
	elif not room.selected:
		animation.play("RESET")

func set_room(value: Room) -> void:
	room = value
	position = room.position
	line.rotation = randi_range(0, 360)
	sprite.texture = ICONS[room.type][0]
	sprite.scale = ICONS[room.type][1]

func show_selected() -> void:
	line.modulate = Color.WHITE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	room.selected = true
	clicked.emit(room)
	animation.play("select")

# Called by the animation player when 'selected' animation completes
func _on_map_room_selected() -> void:
	selected_room.emit(room)
