class_name EnemyAction
extends Node

enum Type {CONDITIONAL, CHANCE}

@export var intent: Intent
@export var type: Type
@export var actionName: String
@export var sound: AudioStream
@export_range(0.0, 10.0) var chanceWeight := 0.0

@onready var accumulatedWeight := 0.0

var enemy: Enemy
var target: Node2D

func is_performable() -> bool:
	return false

func perform_action() -> void:
	Events.enemy_action_completed.emit(enemy)

func update_intent_text() -> void:
	intent.currentText = intent.baseText
