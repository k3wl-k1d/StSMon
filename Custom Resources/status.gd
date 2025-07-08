class_name Status
extends Resource

signal status_applied(status: Status)
signal status_changed

enum Type {START_OF_TURN, END_OF_TURN, EVENT_BASED}
enum StackType {NONE, INTENSITY, DURATION, BOTH}

@export_group("Status Data")
@export var id: String
@export var type: Type
@export var stackType: StackType
@export var canExpire: bool
@export var canBeNegative: bool
@export var duration: int: set = set_duration
@export var stacks: int: set = set_stacks

@export_group("Status Visuals")
@export var name: String
@export var icon: Texture
@export_multiline var tooltip: String

func initialize_status(_target: Node) -> void:
	pass

func apply_status(_target: Node) -> void:
	status_applied.emit(self)

func get_tooltip() -> String:
	return tooltip

func set_duration(value: int) -> void:
	if value >= 0:
		duration = value
		status_changed.emit()

func set_stacks(value: int) -> void:
	if value >= 0:
		stacks = value
		status_changed.emit()
