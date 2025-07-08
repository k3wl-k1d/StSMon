class_name RelicsControl
extends Control

const RELICS_PER_PAGE := 5
const TWEEN_SCROLL_DURATION := 0.2

@export var leftButton: TextureButton
@export var rightButton: TextureButton

@onready var relics: HBoxContainer = %Relics
@onready var pageWidth = self.custom_minimum_size.x

var numRelics := 0
var currentPage := 1
var maxPage := 0
var tween: Tween

func _ready() -> void:
	leftButton.pressed.connect(_on_left_pressed)
	rightButton.pressed.connect(_on_right_pressed)
	
	for relicUI: RelicUI in relics.get_children():
		relicUI.free()
	
	relics.child_order_changed.connect(_on_relics_child_order_changed)

func update() -> void:
	if not is_instance_valid(leftButton) or not is_instance_valid(rightButton):
		return
	
	numRelics = relics.get_child_count()
	maxPage = ceili(numRelics / float(RELICS_PER_PAGE))
	
	leftButton.disabled = currentPage <= 1
	rightButton.disabled = currentPage >= maxPage

func _tween_to(xPosition: float) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(relics, "position:x", xPosition, TWEEN_SCROLL_DURATION)

func _on_left_pressed() -> void:
	if currentPage > 1:
		currentPage -= 1
		update()
		_tween_to(relics.position.x + pageWidth)

func _on_right_pressed() -> void:
	if currentPage < maxPage:
		currentPage += 1
		update()
		_tween_to(relics.position.x - pageWidth)

func _on_relics_child_order_changed() -> void:
	update()
