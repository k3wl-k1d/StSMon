extends EnemyAction

@export var block := 14

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var blockEffect := BlockEffect.new()
	blockEffect.amount = block
	blockEffect.sound = sound
	blockEffect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)

# If the enemy has dynamic intent text, you can override the base behaviour here
# Note that this is an override of update_intent_text() from EnemyAction
# e.g. for attack actions, the Player's DMG TAKEN modifier modifies the resulting damage number
func update_intent_text() -> void:
	intent.currentText = intent.baseText % block
