class_name RelicTooltip
extends Control

@onready var icon: TextureRect = %RelicIcon
@onready var desc: RichTextLabel = %Description
@onready var button: Button = %BackButton

func _ready() -> void:
	button.pressed.connect(hide)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide()

func show_tooltip(relic: Relic) -> void:
	icon.texture = relic.icon
	desc.text = relic.get_tooltip()
	show()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and visible:
		hide()
