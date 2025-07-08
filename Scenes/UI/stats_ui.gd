class_name StatsUI
extends HBoxContainer

@onready var block: HBoxContainer = $Block
@onready var blockLabel: Label = %BlockLabel
@onready var health: HealthUI = $Health

func update_stats(stats: Stats) -> void:
	blockLabel.text = str(stats.block)
	health.update_stats(stats)
	
	block.visible = stats.block > 0
	health.visible = stats.health > 0
