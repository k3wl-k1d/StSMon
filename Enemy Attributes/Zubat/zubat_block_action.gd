extends EnemyAction

@export var block := 4

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

func update_intent_text() -> void:
	intent.currentText = intent.baseText % block
