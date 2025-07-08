class_name CardMenuUI
extends CenterContainer

signal tooltip_requested(card: Card)

const BASE_STYLEBOX := preload("res://Scenes/CardUI/Styleboxes/Normal/normal_base_card_stylebox.tres")
const HOVER_STYLEBOX := preload("res://Scenes/CardUI/Styleboxes/Normal/normal_hover_card_stylebox.tres")

@export var card: Card: set = set_card
@onready var visuals: CardVisuals = $Visuals

func _on_visuals_mouse_entered() -> void:
	visuals.panel.set("theme_override_styles/panel", card.cardHoverStylebox)


func _on_visuals_mouse_exited() -> void:
	visuals.panel.set("theme_override_styles/panel", card.cardBaseStylebox)


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(card)


func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	visuals.card = card
