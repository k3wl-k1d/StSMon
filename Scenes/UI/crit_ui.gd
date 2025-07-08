class_name CritUI
extends VBoxContainer

@onready var label: RichTextLabel = %Label
@onready var crit1: ColorRect = $"1"
@onready var crit2: ColorRect = $"2"
@onready var crit3: ColorRect = $"3"
@onready var crit4: ColorRect = $"4"
@onready var crit5: ColorRect = $"5"
@onready var crit6: ColorRect = $"6"
@onready var crit7: ColorRect = $"7"
@onready var crit8: ColorRect = $"8"
@onready var crit9: ColorRect = $"9"

const EMPTY_COLOUR := "525252"
const READY_COLOUR := "ffff8c"
const LABEL_TEXT := "[center]%s/9[/center]"

var critBars: Array[ColorRect]
var currentBar: int

func _ready() -> void:
	critBars = [crit1,crit2,crit3,crit4,crit5,crit6,crit7,crit8,crit9]
	
	for crit: ColorRect in critBars:
		crit.color = EMPTY_COLOUR
	currentBar = clampi(PokemonTeam.critMeter, 0, PokemonTeam.CRIT_CHARGE_MAX-1)
	label.text = LABEL_TEXT % currentBar
	for i: int in currentBar:
		critBars[i].color = READY_COLOUR
	
	Events.reset_crit.connect(_on_crit_reset)
	Events.increase_crit.connect(_on_crit_increased)

func _on_crit_increased(amount: int) -> void:
	currentBar = clampi(currentBar + amount, 0, PokemonTeam.CRIT_CHARGE_MAX-1)
	label.text = LABEL_TEXT % currentBar
	for i: int in currentBar:
		critBars[i].color = READY_COLOUR

func _on_crit_reset() -> void:
	currentBar = 0
	label.text = LABEL_TEXT % 0
	for i: int in critBars.size():
		critBars[i].color = EMPTY_COLOUR
