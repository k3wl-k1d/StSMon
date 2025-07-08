class_name EnemyHandler
extends Node2D

var skipTurn := false

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	Events.skip_current_turn.connect(func(target): 
		if target is Enemy:
			skipTurn = true)

func setup_enemies(battleStats: BattleStats) -> void:
	if not battleStats:
		return
	
	for enemy: Enemy in get_children():
		remove_child(enemy)
		enemy.queue_free()
	
	if not Events.enemy_fainted.is_connected(_on_enemy_fainted):
		Events.enemy_fainted.connect(_on_enemy_fainted)
	
	var allNewEnemies := battleStats.enemies.instantiate()
	
	for newEnemy: Area2D in allNewEnemies.get_children():
		var newEnemyChild := newEnemy.duplicate() as Enemy
		add_child(newEnemyChild)
		newEnemyChild.statusHandler.statuses_applied.connect(_on_enemy_statuses_applied.bind(newEnemyChild))
	allNewEnemies.queue_free()

func reset_enemy_actions_all() -> void:
	var enemy: Enemy
	for child in get_children():
		enemy = child as Enemy
		enemy.arrow.hide()
		enemy.currentAction = null
		enemy.update_action()

func reset_enemy_actions(enemy: Enemy) -> void:
	enemy.arrow.hide()
	enemy.currentAction = null
	enemy.update_action()

func start_turn(member: Enemy) -> void:
	if not member:
		return
	member.arrow.show()
	member.statusHandler.apply_statuses_by_type(Status.Type.START_OF_TURN)

func _on_enemy_statuses_applied(type: Status.Type, enemy: Enemy) -> void:
	match type:
		Status.Type.START_OF_TURN:
			if not skipTurn:
				enemy.do_turn()
			else:
				Events.enemy_action_completed.emit(enemy)
			skipTurn = false

func _on_enemy_fainted(enemy: Enemy) -> void:
	if not enemy:
		return
	remove_child(enemy)
	if get_child_count() <= 0:
		Events.all_enemies_fainted.emit()

func _on_player_hand_drawn() -> void:
	for enemy: Enemy in get_children():
		enemy.update_intent()
