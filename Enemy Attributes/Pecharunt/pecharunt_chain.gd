extends EnemyAction

const CONFUSION := preload("res://Colourless Cards/confusion.tres")

@export var damage := 8

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
	var modifiedDamage := enemy.modifierHandler.get_modified_value(damage, Modifier.Type.DMG_DEALT)
	
	damageEffect.amount = modifiedDamage
	damageEffect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damageEffect.execute.bind(targetArray))
	tween.tween_callback(PokemonTeam.drawPile.add_card.bind(CONFUSION.duplicate()))
	tween.tween_callback(PokemonTeam.drawPile.add_card.bind(CONFUSION.duplicate()))
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
	var finalDmg := enemy.modifierHandler.get_modified_value(modifiedDmg, Modifier.Type.DMG_DEALT)
	intent.currentText = intent.baseText % finalDmg
