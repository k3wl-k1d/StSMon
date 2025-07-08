class_name Player
extends Entity

@export var stats: CharacterStats: set = set_character_stats

#func _ready() -> void:
	#var curse := preload("res://Statuses/intimidation.tres").duplicate()
	#curse.duration = 4
	#statusHandler.add_status(curse)

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	sprite2D.sprite_frames = stats.animation
	sprite2D.play()
	arrow.position = Vector2(get_animated_sprite_2d_size().x / 2, get_animated_sprite_2d_size().y / -2 + ARROW_OFFSET)
	update_stats()

func update_stats() -> void:
	statsUI.update_stats(stats)

func take_damage(damage: int, whichModifier: Modifier.Type) -> void:
	if stats.health <= 0:
		return
	var currentHealth := stats.health
	
	sprite2D.material = WHITE_SPRITE_MATERIAL
	var modifiedDamage := modifierHandler.get_modified_value(damage, whichModifier)
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modifiedDamage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite2D.material = null
			if stats.health < currentHealth:
				Events.detonate_poison.emit(self)
			if stats.health <= 0:
				Events.player_died.emit(self)
				sprite2D.modulate = Color(0.4,0.4,0.4,0.6)
				sprite2D.pause()
				#queue_free()
	)

func get_health_after_damage(damage: int, whichModifier: Modifier.Type) -> int:
	var modifiedDamage := modifierHandler.get_modified_value(damage, whichModifier)
	return stats.get_take_damage_difference(modifiedDamage)

func get_animated_sprite_2d_size() -> Vector2:
	return sprite2D.sprite_frames.get_frame_texture(sprite2D.animation, sprite2D.frame).get_size()

func get_speed() -> int:
	var newSpeed := clampi(modifierHandler.get_modified_value(stats.speed, Modifier.Type.SPEED), 1, 10000)
	return newSpeed

func kill_entity() -> void:
	take_damage(999, Modifier.Type.NO_MODIFIER)
