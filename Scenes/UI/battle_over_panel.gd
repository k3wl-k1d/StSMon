class_name BattleOverPanel
extends Panel

const MAIN_MENU := preload("res://Scenes/UI/main_menu.tscn")
const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continueButton: Button = %ContinueButton
@onready var mainMenuButton: Button = %MainMenuButton

func _ready() -> void:
	continueButton.pressed.connect(func(): Events.battle_won.emit())
	mainMenuButton.pressed.connect(get_tree().change_scene_to_file.bind(MAIN_MENU_PATH))
	Events.battle_over_screen_requested.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continueButton.visible = type == Type.WIN
	mainMenuButton.visible = type == Type.LOSE 
	show()
	get_tree().paused = true
