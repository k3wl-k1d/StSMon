class_name StatusUI
extends Control

@export var status: Status: set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks

func set_status(value: Status) -> void:
	if not is_node_ready():
		await ready
	status = value
	icon.texture = status.icon
	duration.visible = status.stackType == Status.StackType.DURATION
	stacks.visible = status.stackType == Status.StackType.INTENSITY
	custom_minimum_size = icon.size
	
	if duration.visible:
		custom_minimum_size = duration.size + duration.position
	elif stacks.visible:
		custom_minimum_size = stacks.size + stacks.position
	
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_on_status_changed()

func _on_status_changed() -> void:
	if not status:
		return
	
	if status.canExpire and status.duration <= 0:
		queue_free()
	
	if status.stackType == Status.StackType.INTENSITY:
		if status.canBeNegative:
			if status.stacks == 0:
				queue_free()
		else:
			if status.stacks <= 0:
				queue_free()
	
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
