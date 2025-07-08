extends EnemyAction

@export var damage := 6

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var player := target as Player
	if not player:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damageEffect := DamageEffect.new()
	var targetArray: Array[Node] = [target]
	
	damageEffect.amount = damage
	damageEffect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(func():
		damageEffect.execute(targetArray)
		enemy.stats.heal(damage))
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)

# If the enemy has dynamic intent text, you can override the base behaviour here
# Note that this is an override of update_intent_text() from EnemyAction
# e.g. for attack actions, the Player's DMG TAKEN modifier modifies the resulting damage number
func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modifiedDmg := player.modifierHandler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	intent.currentText = intent.baseText % modifiedDmg
