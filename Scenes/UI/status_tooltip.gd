class_name StatusTooltip
extends HBoxContainer

@export var status: Status: set = set_status

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

func set_status(value: Status) -> void:
	if not is_node_ready():
		await ready
	
	status = value
	icon.texture = status.icon
	label.text = status.get_tooltip()
