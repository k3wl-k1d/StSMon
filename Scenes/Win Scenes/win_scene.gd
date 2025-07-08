class_name WinScene
extends Control

const MAIN_MENU := "res://Scenes/UI/main_menu.tscn"
const MESSAGE := "%s and %s are victorious!"

@export var char1: CharacterStats: set = set_char1
@export var char2: CharacterStats: set = set_char2

@onready var message: Label = %Message
@onready var char1Portrait: TextureRect = %CharacterPortrait
@onready var char2Portrait: TextureRect = %CharacterPortrait2

var char1Name: String
var char2Name: String

func set_char1(value: CharacterStats) -> void:
	char1 = value
	char1Portrait.texture = char1.icon
	char1Name = char1.name
	set_message_names()

func set_char2(value: CharacterStats) -> void:
	char2 = value
	char2Portrait.texture = char2.icon
	char2Name = char2.name
	set_message_names()

func set_message_names() -> void:
	if (char1Name and char2Name) and (char1 and char2):
		message.text = MESSAGE % [char1Name, char2Name]

func _on_main_menu_button_pressed() -> void:
	PokemonTeam.reset_game()
	get_tree().change_scene_to_file(MAIN_MENU)
