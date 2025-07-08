class_name HealthUI
extends HBoxContainer

@export var showMaxHP: bool
@export var showIcon: bool

@onready var currentHealth: Label = %HealthLabel
@onready var maxHealth: Label = %MaxHealthLabel
@onready var icon: TextureRect = %Icon

func update_stats(stats: Stats) -> void:
	currentHealth.text = str(stats.health)
	maxHealth.text = "/%s" % str(stats.maxHealth)
	maxHealth.visible = showMaxHP
	icon.texture = stats.icon
	icon.visible = showIcon
