class_name Entity
extends Area2D

const ARROW_OFFSET := 2
const WHITE_SPRITE_MATERIAL := preload("res://Pokemon Assets/white_sprite_material.tres")
@onready var arrow: Sprite2D = $Arrow
@onready var statsUI: StatsUI = $StatsUI as StatsUI
@onready var sprite2D: AnimatedSprite2D = $EntityAnimation
@onready var statusHandler: StatusHandler = $StatusHandler
@onready var modifierHandler: ModifierHandler = $ModifierHandler

func _on_area_entered(_area: Area2D) -> void:
	sprite2D.modulate = Color(1,1,1,0.5)
	#arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	sprite2D.modulate = Color(1,1,1,1)
	#arrow.hide()

func get_speed() -> int:
	return 1

func _do_turn() -> void:
	pass

func kill_entity() -> void:
	pass
