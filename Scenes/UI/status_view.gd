class_name StatusView
extends Control

const STATUS_TOOLTIP := preload("res://Scenes/UI/status_tooltip.tscn")

@onready var statusTooltips: VBoxContainer = $"%StatusTooltips"

func _ready() -> void:
	for tooltip: StatusTooltip in statusTooltips.get_children():
		tooltip.queue_free()
	
	Events.status_tooltip_requested.connect(show_view)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide_view()

func show_view(statuses: Array[Status]) -> void:
	for status: Status in statuses:
		var newStatusTooltip := STATUS_TOOLTIP.instantiate() as StatusTooltip
		statusTooltips.add_child(newStatusTooltip)
		newStatusTooltip.status = status
	show()

func hide_view() -> void:
	for tooltip: StatusTooltip in statusTooltips.get_children():
		tooltip.queue_free()
	hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and visible:
		hide_view()

func _on_back_button_pressed() -> void:
	hide_view()
