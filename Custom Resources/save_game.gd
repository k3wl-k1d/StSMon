class_name SaveGame
extends Resource

const SAVE_PATH := "user://savegame.tres"

@export var rngSeed: int
@export var rngState: int
@export var runStats: RunStats
@export var charStatsP1: CharacterStats
@export var charStatsP2: CharacterStats
@export var currentDeck: CardPile
@export var char1StartingDeck: CardPile
@export var char2StartingDeck: CardPile
@export var char1Evolution: EvolutionRequirements
@export var char2Evolution: EvolutionRequirements
@export var currentHealthP1: int
@export var currentHealthP2: int
@export var speedP1: int
@export var speedP2: int
@export var relics: Array[Relic]
@export var mapData: Array[Array]
@export var lastRoom: Room
@export var floorsClimbed: int
@export var wasOnMap: bool
@export var currentCrit: int

func save_data() -> void:
	var err := ResourceSaver.save(self, SAVE_PATH)
	assert(err == OK, "\n\t!!!COULDN'T SAVE THE GAME!!!\t\n")

static func load_data() -> SaveGame:
	if FileAccess.file_exists(SAVE_PATH):
		print("\n\t!!!LOADING THE GAME!!!\t\n")
		return ResourceLoader.load(SAVE_PATH) as SaveGame
	
	print("\n\t!!!COULDN'T LOAD THE GAME!!!\t\n")
	return null

static func delete_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
