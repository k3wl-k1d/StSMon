extends Control

const CHARACTER_SLECTOR := preload("res://Scenes/UI/character_selector.tscn")
const RUN_SCENE := preload("res://Scenes/Run/run.tscn")

@export var runStartup: RunStartup

@onready var munchlax: AnimatedSprite2D = $Munchlax
@onready var gimmighoul: AnimatedSprite2D = $Gimmighoul
@onready var foongus: AnimatedSprite2D = $Foongus
@onready var noibat: AnimatedSprite2D = $Noibat
@onready var rattata: AnimatedSprite2D = $Rattata
@onready var zubat: AnimatedSprite2D = $Zubat
@onready var clefairy: AnimatedSprite2D = $Clefairy
@onready var caterpie: AnimatedSprite2D = $Caterpie
@onready var continueButton: Button = %Continue

func _ready() -> void:
	MusicPlayer.stop()
	get_tree().paused = false
	continueButton.disabled = SaveGame.load_data() == null
	munchlax.play()
	#gimmighoul.play()
	#noibat.play()
	foongus.play()
	rattata.play()
	zubat.play()
	clefairy.play()
	caterpie.play()

func _on_continue_pressed() -> void:
	print("Continue run")
	runStartup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_new_run_pressed() -> void:
	print("New run")
	get_tree().change_scene_to_packed(CHARACTER_SLECTOR)

func _on_exit_pressed() -> void:
	get_tree().quit()
