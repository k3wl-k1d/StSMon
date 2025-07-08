class_name Run
extends Node

const BATTLE_SCENE := preload("res://Scenes/Battles/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://Scenes/Battle Rewards/battle_rewards.tscn")
const POKECENTER_SCENE := preload("res://Scenes/Pokecenter/pokecenter.tscn")
const TREASURE_SCENE := preload("res://Scenes/Treasure/treasure.tscn")
const SHOP_SCENE := preload("res://Scenes/Shop/shop.tscn")
const WIN_SCENE := preload("res://Scenes/Win Scenes/win_scene.tscn")
const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

const SUPER_POTION := preload("res://Relics/super_potion.tres")

@export var runStartup: RunStartup

@onready var map: Map = $Map
@onready var currentView: Node = $CurrentView
@onready var deckButton: CardPileOpener = %DeckButton
@onready var deckView: CardPileView = %DeckView
@onready var goldUI: GoldUI = %GoldUI
@onready var p1Health: HealthUI = %P1Health
@onready var p2Health: HealthUI = %P2Health
@onready var relicHandler: RelicHandler = %RelicHandler
@onready var relicTooltip: RelicTooltip = %RelicTooltip
@onready var pauseMenu: PauseMenu = $PauseMenu

@onready var mapButton: Button = %MapButton
@onready var battleButton: Button = %BattleButton
@onready var shopButton: Button = %ShopButton
@onready var treasureButton: Button = %TreasureButton
@onready var rewardsButton: Button = %RewardsButton
@onready var pokecenterButton: Button = %PokecenterButton

var stats: RunStats
var characterP1: CharacterStats
var characterP2: CharacterStats
var saveData: SaveGame

func _ready() -> void:
	if not runStartup:
		print("No run startup detected")
		return
	
	pauseMenu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	
	match runStartup.type:
		RunStartup.Type.NEW_RUN:
			characterP1 = runStartup.pickedCharacterP1.create_instance()
			characterP2 = runStartup.pickedCharacterP2.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			_load_run()
		_:
			print("Error: Type not matching on run startup")
	PokemonTeam.teammate1 = characterP1
	PokemonTeam.teammate2 = characterP2
	
	PokemonTeam.set_deck()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)

func _start_run() -> void:
	stats = RunStats.new()
	_setup_connection_events()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)
	
	saveData = SaveGame.new()
	_save_run(true)

func _save_run(wasOnMap: bool) -> void:
	saveData.rngSeed = RNG.instance.seed
	saveData.rngState = RNG.instance.state
	saveData.runStats = stats
	saveData.charStatsP1 = characterP1
	saveData.charStatsP2 = characterP2
	saveData.currentDeck = PokemonTeam.deck
	saveData.char1StartingDeck = characterP1.startingDeck
	saveData.char2StartingDeck = characterP2.startingDeck
	saveData.currentHealthP1 = characterP1.health
	saveData.currentHealthP2 = characterP2.health
	saveData.speedP1 = characterP1.speed
	saveData.speedP2 = characterP2.speed
	saveData.relics = relicHandler.get_all_relics()
	saveData.lastRoom = map.lastRoom
	saveData.mapData = map.mapData.duplicate()
	saveData.floorsClimbed = map.floorsClimbed
	saveData.wasOnMap = wasOnMap
	saveData.save_data()

func _load_run() -> void:
	saveData = SaveGame.load_data()
	assert(saveData, "\n\t!!!COULDN'T LOAD LAST SAVE!!!\t\n")
	
	RNG.set_from_save_data(saveData.rngSeed, saveData.rngState)
	stats = saveData.runStats
	characterP1 = saveData.charStatsP1
	characterP2 = saveData.charStatsP2
	characterP1.health = saveData.currentHealthP1
	characterP2.health = saveData.currentHealthP2
	characterP1.speed = saveData.speedP1
	characterP2.speed = saveData.speedP2
	characterP1.baseIcon = characterP1.icon
	characterP2.baseIcon = characterP2.icon
	characterP1.startingDeck = saveData.char1StartingDeck
	characterP2.startingDeck = saveData.char2StartingDeck
	PokemonTeam.deck = saveData.currentDeck
	relicHandler.add_relics(saveData.relics)
	_setup_top_bar()
	_setup_connection_events()
	
	map.load_map(saveData.mapData, saveData.floorsClimbed, saveData.lastRoom)
	if saveData.lastRoom and not saveData.wasOnMap:
		_on_map_exited(saveData.lastRoom)

func _change_view(scene: PackedScene) -> Node:
	if currentView.get_child_count() > 0:
		currentView.get_child(0).queue_free()
	
	get_tree().paused = false
	var newScene := scene.instantiate()
	currentView.add_child(newScene)
	map.hide_map()
	
	return newScene

func _show_map() -> void:
	if currentView.get_child_count() > 0:
		currentView.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()
	
	_save_run(true)

func _setup_connection_events() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.pokecenter_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_on_treasure_room_exited)
	Events.event_room_exited.connect(_show_map)
	
	battleButton.pressed.connect(_change_view.bind(BATTLE_SCENE))
	pokecenterButton.pressed.connect(_change_view.bind(POKECENTER_SCENE))
	treasureButton.pressed.connect(_change_view.bind(TREASURE_SCENE))
	shopButton.pressed.connect(_change_view.bind(SHOP_SCENE))
	rewardsButton.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	mapButton.pressed.connect(_show_map)

func _setup_top_bar() -> void:
	characterP1.stats_changed.connect(p1Health.update_stats.bind(characterP1))
	characterP2.stats_changed.connect(p2Health.update_stats.bind(characterP2))
	p1Health.update_stats(characterP1)
	p2Health.update_stats(characterP2)
	
	goldUI.runStats = stats
	
	if not relicHandler.has_relic("super_potion"):
		relicHandler.add_relic(SUPER_POTION.duplicate())
	if characterP1.startingRelic:
		relicHandler.add_relic(characterP1.startingRelic)
	if characterP2.startingRelic:
		relicHandler.add_relic(characterP2.startingRelic)
	Events.relic_tooltip_requested.connect(relicTooltip.show_tooltip)
	
	deckButton.cardPile = PokemonTeam.deck
	deckView.cardPile = PokemonTeam.deck
	deckButton.pressed.connect(deckView.show_current_view.bind("Deck"))

func _show_regular_battle_rewards() -> void:
	var rewardScene := _change_view(BATTLE_REWARD_SCENE) as BattleRewards
	rewardScene.runStats = stats
	rewardScene.charStatsP1 = characterP1
	rewardScene.charStatsP2 = characterP2
	
	characterP1.block = 0
	characterP2.block = 0
	
	rewardScene.add_gold_reward(map.lastRoom.battleStats.roll_gold_reward())
	rewardScene.add_card_reward()
	
	if relicHandler.has_relic("loaded_dice"):
		rewardScene.add_gold_reward(RNG.instance.randi_range(1,6))
	if relicHandler.has_relic("loaded_dice_gimmighoul"):
		rewardScene.add_gold_reward(12)

func _on_battle_room_entered(room: Room) -> void:
	var battleScene: Battle = _change_view(BATTLE_SCENE) as Battle
	battleScene.charStatsP1 = characterP1
	battleScene.charStatsP2 = characterP2
	battleScene.battleStats = room.battleStats
	battleScene.relicHandler = relicHandler
	battleScene.start_battle()

func _on_treasure_room_entered() -> void:
	var treasure := _change_view(TREASURE_SCENE) as Treasure
	treasure.relicHandler = relicHandler
	treasure.charStatsP1 = characterP1
	treasure.charStatsP2 = characterP2
	treasure.generate_relic()

func _on_treasure_room_exited(relic: Relic) -> void:
	var rewardScene := _change_view(BATTLE_REWARD_SCENE) as BattleRewards
	rewardScene.runStats = stats
	rewardScene.charStatsP1 = characterP1
	rewardScene.charStatsP2 = characterP2
	rewardScene.relicHandler = relicHandler
	rewardScene.add_relic_reward(relic)
	rewardScene.add_gold_reward(randi_range(20,49))

func _on_pokecenter_room_entered() -> void:
	var pokecenter := _change_view(POKECENTER_SCENE) as Pokecenter
	pokecenter.charStatsP1 = characterP1
	pokecenter.charStatsP2 = characterP2

func _on_shop_room_entered() -> void:
	var shop := _change_view(SHOP_SCENE) as Shop
	shop.char1 = characterP1
	shop.char2 = characterP2
	shop.runStats = stats
	shop.relicHandler = relicHandler
	Events.shop_entered.emit(shop)
	shop.populate_shop()

func _on_event_room_entered(room: Room) -> void:
	var eventRoom := _change_view(room.eventScene) as EventRoom
	eventRoom.characterStatsP1 = characterP1
	eventRoom.characterStatsP2 = characterP2
	eventRoom.runStats = stats
	eventRoom.setup()

func _on_battle_won() -> void:
	if map.floorsClimbed == MapGenerator.FLOORS:
		var winScreen := _change_view(WIN_SCENE) as WinScene
		winScreen.char1 = characterP1
		winScreen.char2 = characterP2
		SaveGame.delete_data()
	else:
		_show_regular_battle_rewards()

func _on_map_exited(room: Room) -> void:
	_save_run(false)
	
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_on_treasure_room_entered()
		Room.Type.SHOP:
			_on_shop_room_entered()
		Room.Type.POKECENTER:
			_on_pokecenter_room_entered()
		Room.Type.EVENT:
			_on_event_room_entered(room)
		Room.Type.BOSS:
			_on_battle_room_entered(room)
