class_name RelicUI
extends Control

@export var relic: Relic: set = set_relic

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label
@onready var animation: AnimationPlayer = $AnimationPlayer

func set_relic(value: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = value
	icon.texture = relic.icon
	if relic.consumable:
		label.text = str(relic.currentStacks)
	else:
		label.text = ""

func update_relic_ui() -> void:
	icon.texture = relic.icon
	if relic.consumable or relic.shouldDisplayStacks:
		label.text = str(relic.currentStacks)
	else:
		label.text = ""

func flash() -> void:
	animation.play("flash")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.relic_tooltip_requested.emit(relic)
