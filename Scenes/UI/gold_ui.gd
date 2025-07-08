class_name GoldUI
extends HBoxContainer

@export var runStats: RunStats: set = set_run_stats

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "0"

func set_run_stats(value: RunStats) -> void:
	runStats = value
	
	if not runStats.gold_changed.is_connected(_update_gold):
		runStats.gold_changed.connect(_update_gold)
		_update_gold()

func _update_gold() -> void:
	label.text = str(runStats.gold)
