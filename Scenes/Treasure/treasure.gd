class_name Treasure
extends Control

@export var treasureRelicPool: Array[Relic]
@export var relicHandler: RelicHandler
@export var charStatsP1: CharacterStats
@export var charStatsP2: CharacterStats

@onready var animation: AnimationPlayer = %AnimationPlayer
var foundRelic: Relic

func generate_relic() -> void:
	var availableRelics := treasureRelicPool.filter(
		func(relic: Relic):
			var canAppear := relic.can_appear_as_reward(charStatsP1, charStatsP2)
			var alreadyHadIt := relicHandler.has_relic(relic.id)
			return canAppear and not alreadyHadIt
	)
	
	foundRelic = RNG.array_pick_random(availableRelics)

# Called from the animation player at the end of 'opening' animation
func _on_treasure_opened() -> void:
	Events.treasure_room_exited.emit(foundRelic)

func _on_treasure_chest_gui_input(event: InputEvent) -> void:
	if animation.current_animation == "opening":
		return
	
	if event.is_action_pressed("left_mouse"):
		animation.play("opening")

func _on_button_pressed() -> void:
	Events.treasure_room_exited.emit()
