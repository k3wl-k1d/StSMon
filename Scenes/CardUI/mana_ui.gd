class_name ManaUI
extends Panel

@export var charStatsP1: CharacterStats: set = _set_char_stats_P1
@export var charStatsP2: CharacterStats: set = _set_char_stats_P2
@onready var manaLabel: Label = $ManaLabel

func _set_char_stats_P1(value: CharacterStats) -> void:
	charStatsP1 = value
	
	if not charStatsP1.stats_changed.is_connected(_on_stats_changed):
		charStatsP1.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _set_char_stats_P2(value: CharacterStats) -> void:
	charStatsP2 = value
	
	if not charStatsP2.stats_changed.is_connected(_on_stats_changed):
		charStatsP2.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _on_stats_changed() -> void:
	manaLabel.text = "%s/%s" % [PokemonTeam.active.stats.mana, PokemonTeam.active.stats.maxMana]
