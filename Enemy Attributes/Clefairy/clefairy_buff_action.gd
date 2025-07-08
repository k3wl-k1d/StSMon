extends EnemyAction

const STRENGTH := preload("res://Statuses/strength.tres")
const DETECT := preload("res://Statuses/detect.tres")

@export var stacksPerAction := 1

var usages := 0

func is_performable() -> bool:
	if usages == 0:
		
		usages += 1
		return true
	
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var statusEffect := StatusEffect.new()
	var strength := STRENGTH.duplicate()
	var detect := DETECT.duplicate()
	strength.stacks = stacksPerAction
	detect.stacks = stacksPerAction
	statusEffect.status = strength
	statusEffect.execute([enemy])
	statusEffect.status = detect
	statusEffect.execute([enemy])
	
	SFXPlayer.play(sound)
	Events.enemy_action_completed.emit(enemy)
