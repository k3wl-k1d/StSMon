class_name Battle
extends Node2D

@export var charStatsP1: CharacterStats
@export var charStatsP2: CharacterStats
@export var music: AudioStream
@export var battleStats: BattleStats
@export var relicHandler: RelicHandler

@onready var battleUI: BattleUI = $BattleUI
@onready var playerHandler: PlayerHandler = %PlayerHandler
@onready var enemyHandler: EnemyHandler = %EnemyHandler
@onready var entityHandler: EntityHandler = $EntityHandler

var turn1: bool = true

func _ready() -> void:
	Events.all_enemies_fainted.connect(_on_all_enemies_fainted)
	Events.entity_fainted_early.connect(func():
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(entityHandler.currentEntity) and entityHandler.currentEntity is Player:
			playerHandler.end_turn()
		else:
			allocate_turn(entityHandler.choose_turn()))
	
	Events.player_turn_ended.connect(playerHandler.end_turn)
	Events.player_hand_discarded.connect(func():
		allocate_turn(entityHandler.choose_turn()))
	
	Events.enemy_action_completed.connect(func(enemy): 
		enemy.statusHandler.apply_statuses_by_type(Status.Type.END_OF_TURN)
		enemy.playingTurn = false
		enemyHandler.reset_enemy_actions(enemy)
		await get_tree().create_timer(0.5).timeout
		allocate_turn(entityHandler.choose_turn()))
	Events.both_players_died.connect(_on_both_player_died)
	
func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	for enemy: Enemy in enemyHandler.get_children():
		enemy.queue_free()
	
	PokemonTeam.active = playerHandler.get_children()[0]
	PokemonTeam.players = playerHandler.get_children()
	
	battleUI.charStatsP1 = charStatsP1
	battleUI.charStatsP2 = charStatsP2
	
	playerHandler.relics = relicHandler
	
	enemyHandler.setup_enemies(battleStats)
	enemyHandler.reset_enemy_actions_all()
	
	Events.battle_started.emit()
	
	relicHandler.relics_activated.connect(_on_relics_activated)
	relicHandler.activate_relics_by_type(Relic.Type.START_OF_COMBAT)

func allocate_turn(member: Entity) -> void:
	if not Entity:
		print("Received Entity in allocate_turn is neither Player or Enemey")
		return
	
	Events.turn_order_changed.emit(member, entityHandler.get_turn_order())
	
	if turn1:
		await get_tree().create_timer(1).timeout
		turn1 = false
	
	if member is Player:
		PokemonTeam.active = member
		playerHandler.start_turn(member)
	elif member is Enemy:
		enemyHandler.start_turn(member)
	
	print("\n\n===============================\n\n")

func _on_all_enemies_fainted() -> void:
	if enemyHandler.get_child_count() == 0 and is_instance_valid(relicHandler):
		relicHandler.activate_relics_by_type(Relic.Type.END_OF_COMBAT)

func _on_both_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
	PokemonTeam.fainted.clear()
	SaveGame.delete_data()

func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_COMBAT:
			playerHandler.start_battle(charStatsP1, charStatsP2)
			entityHandler.set_turn_order()
			battleUI.initialize_card_pile_ui()
			allocate_turn(entityHandler.choose_turn())
		Relic.Type.END_OF_COMBAT:
			Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)
			MusicPlayer.stop()
			PokemonTeam.revive_players()
