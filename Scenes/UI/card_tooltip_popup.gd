class_name CardTooltipPopup
extends Control

const CARD_MENU_UI_SCENE := preload("res://Scenes/CardMenuUI/card_menu_ui.tscn")

@export var backgroundColour: Color = Color("00000090")

@onready var background: ColorRect = $Background
@onready var tooltipCard: CenterContainer = %TooltipCard
@onready var description: RichTextLabel = %Description

func _ready() -> void:
	for card: CardMenuUI in tooltipCard.get_children():
		card.queue_free()
	
	background.color = backgroundColour

func show_tooltip(card: Card) -> void:
	var newCard := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
	tooltipCard.add_child(newCard)
	newCard.card = card
	newCard.tooltip_requested.connect(hide_tooltip.unbind(1))
	description.text = card.get_default_tooltip()
	show()

func hide_tooltip() -> void:
	if not visible:
		return
	
	for card: CardMenuUI in tooltipCard.get_children():
		card.queue_free()
	hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()
