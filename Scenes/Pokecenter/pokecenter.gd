class_name Pokecenter
extends Control

@export var charStatsP1: CharacterStats
@export var charStatsP2: CharacterStats

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var restButton: Button = %RestButton

func _on_rest_button_pressed() -> void:
	restButton.disabled = true
	charStatsP1.heal(ceili(charStatsP1.maxHealth * 0.3))
	charStatsP2.heal(ceili(charStatsP2.maxHealth * 0.3))
	animation.play("fade_out")

# Called after animation player at the end of 'fade_out'
func _on_fade_out_finished() -> void:
	Events.pokecenter_exited.emit()
