class_name PauseMenu
extends CanvasLayer

signal save_and_quit

@onready var backToGameB: Button = %BackToGameButton
@onready var mainMenuB: Button = %MainMenuButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if visible:
			_unpause()
		else:
			_pause()
		
		get_viewport().set_input_as_handled()

func _pause() -> void:
	show()
	get_tree().paused = true

func _unpause() -> void:
	hide()
	get_tree().paused = false

func _on_main_menu_button_pressed() -> void:
	print("Exiting to main menu")
	get_tree().paused = false
	save_and_quit.emit()

func _on_back_to_game_button_pressed() -> void:
	print("Back")
	_unpause()
