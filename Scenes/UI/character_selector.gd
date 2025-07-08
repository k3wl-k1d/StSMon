extends Control

const RUN_SCENE := preload("res://Scenes/Run/run.tscn")
const MUNCHLAX_STATS := preload("res://Character Attributes/Typings/Normal/Munchlax/Munchlax/munchlax.tres")
const GIMMIGHOUL_STATS := preload("res://Character Attributes/Typings/Ghost/Gimmighoul/gimmighoul.tres")
const FOONGUS_STATS := preload("res://Character Attributes/Typings/Grass/Foongus/Foongus/foongus.tres")
const NOIBAT_STATS := preload("res://Character Attributes/Typings/Flying/Noibat/noibat.tres")

@export var runStartup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var portrait: TextureRect = %CharacterPortrait
@onready var credits: Label = %Credits
@onready var selectedChar: HBoxContainer = $SelectedCharacters
@onready var char1: Button = %Character1Button
@onready var char2: Button = %Character2Button

var currentCharacter: CharacterStats: set = set_current_character
var currentSlot: Button
var characters = {}

func _ready() -> void:
	currentSlot = char1
	characters[char1] = null
	characters[char2] = null
	set_current_character(MUNCHLAX_STATS)

func set_current_character(value: CharacterStats) -> void:
	currentCharacter = value
	title.text = currentCharacter.name
	description.text = currentCharacter.description
	portrait.texture = currentCharacter.icon
	credits.text = currentCharacter.credits
	characters[currentSlot] = currentCharacter
	currentSlot.get_child(0).texture = currentCharacter.icon

func _on_start_button_pressed() -> void:
	if characters[char1] and characters[char2] and characters[char1] != characters[char2]:
		print("Start Run with %s and %s" % [characters[char1].name, characters[char2].name])
		runStartup.type = RunStartup.Type.NEW_RUN
		runStartup.pickedCharacterP1 = characters[char1]
		runStartup.pickedCharacterP2 = characters[char2]
		get_tree().change_scene_to_packed(RUN_SCENE)
	elif characters[char1] == characters[char2]:
		print("Both characters are the same")

func _on_munchlax_button_pressed() -> void:
	currentCharacter = MUNCHLAX_STATS

func _on_gimmighoul_button_pressed() -> void:
	currentCharacter = GIMMIGHOUL_STATS

func _on_foongus_button_pressed() -> void:
	currentCharacter = FOONGUS_STATS

func _on_noibat_button_pressed() -> void:
	currentCharacter = NOIBAT_STATS

func _on_character_1_button_pressed() -> void:
	currentSlot = char1
	set_current_character(currentCharacter)

func _on_character_2_button_pressed() -> void:
	currentSlot = char2
	set_current_character(currentCharacter)
