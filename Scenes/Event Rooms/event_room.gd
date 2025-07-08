class_name EventRoom
extends Control

@export var characterStatsP1: CharacterStats
@export var characterStatsP2: CharacterStats

@export var runStats: RunStats

func setup() -> void:
	pass

func leave() -> void:
	Events.event_room_exited.emit()
