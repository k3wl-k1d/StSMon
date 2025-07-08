extends EnemyAction

const STRENGTH := preload("res://Statuses/strength.tres")

@export var stacksPerAction := 2
@export var hpThreshold := 44

var usages := 0

func is_performable() -> bool:
	var hpUnderThreshold := enemy.stats.health <= hpThreshold
	
	if usages == 0 or (usages == 1 and hpUnderThreshold):
		
		usages += 1
		return true
	
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var statusEffect := StatusEffect.new()
	var strength := STRENGTH.duplicate()
	strength.stacks = stacksPerAction
	statusEffect.status = strength
	statusEffect.execute([enemy])
	
	SFXPlayer.play(sound)
	Events.enemy_action_completed.emit(enemy)
