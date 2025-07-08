class_name Enemy
extends Entity

# For 'Spell Tag' Relic
const CURSE_STATUS := preload("res://Statuses/curse.tres")

@export var stats: EnemyStats: set = set_enemy_stats

# Entity contains StatsUI and Sprite variables
@onready var intentUI: IntentUI = $IntentUI as IntentUI

var enemyActionPicker: EnemyActionPicker
var currentAction: EnemyAction: set = set_current_action
var playingTurn := false
var spellTag := false

func set_current_action(action: EnemyAction) -> void:
	currentAction = action
	update_intent()

func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
	if not Events.spell_tag_activated.is_connected(_on_spell_tag_active):
		Events.spell_tag_activated.connect(_on_spell_tag_active)
	if not Events.spell_tag_deactivated.is_connected(_on_spell_tag_deactive):
		Events.spell_tag_deactivated.connect(_on_spell_tag_deactive)
	
	update_enemy()

func setup_ai() -> void:
	if enemyActionPicker:
		enemyActionPicker.queue_free()
	
	var newActionPicker: EnemyActionPicker = stats.ai.instantiate()
	add_child(newActionPicker)
	enemyActionPicker = newActionPicker
	enemyActionPicker.enemy = self

func update_action() -> void:
	if not enemyActionPicker:
		return
	if not playingTurn:
		enemyActionPicker.set_new_target()
	if not currentAction:
		currentAction = enemyActionPicker.get_action()
		return
	
	# Sets a conditional action if stats update requires to
	var newConditionalAction := enemyActionPicker.get_first_conditional_action()
	if newConditionalAction and currentAction != newConditionalAction:
		currentAction = newConditionalAction

func update_stats() -> void:
	if not statsUI:
		return
	
	statsUI.update_stats(stats)

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	sprite2D.sprite_frames = stats.animation
	sprite2D.play()
	arrow.position = Vector2(get_animated_sprite_2d_size().x / 2, get_animated_sprite_2d_size().y / -2 - ARROW_OFFSET)
	setup_ai()
	update_stats()

func update_intent() -> void:
	if currentAction:
		currentAction.update_intent_text()
		intentUI.update_intent(currentAction.intent)

func do_turn() -> void:
	playingTurn = true
	stats.block = 0
	
	if not currentAction:
		return
	currentAction.perform_action()

func take_damage(damage: int, whichModifier: Modifier.Type) -> void:
	if stats.health <= 0:
		return
	
	var currentHealth := stats.health
	sprite2D.material = WHITE_SPRITE_MATERIAL
	var modifiedDamage := modifierHandler.get_modified_value(damage, whichModifier)
	
	if spellTag and whichModifier != Modifier.Type.NO_MODIFIER:
		if get_health_after_damage(modifiedDamage, Modifier.Type.NO_MODIFIER) < stats.health:
			Events.enemy_hit_without_block.emit(self, clampi(modifiedDamage - stats.block, 0, modifiedDamage))
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(
		func():
			if not spellTag:
				stats.take_damage(modifiedDamage)
			elif spellTag and whichModifier != Modifier.Type.NO_MODIFIER:
				take_damage_until_no_block(modifiedDamage)
			elif spellTag and whichModifier == Modifier.Type.NO_MODIFIER:
				stats.take_damage(modifiedDamage)
			)
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite2D.material = null
			if stats.health < currentHealth:
				Events.detonate_poison.emit(self)
			if stats.health <= 0:
				Events.enemy_fainted.emit(self)
				free()
	)

func get_health_after_damage(damage: int, whichModifier: Modifier.Type) -> int:
	var modifiedDamage := modifierHandler.get_modified_value(damage, whichModifier)
	return stats.get_take_damage_difference(modifiedDamage)

func take_damage_until_no_block(damage: int) -> void:
	if damage >= stats.block:
		stats.take_damage(stats.block)
	else:
		stats.take_damage(damage)

func get_animated_sprite_2d_size() -> Vector2:
	return sprite2D.sprite_frames.get_frame_texture(sprite2D.animation, sprite2D.frame).get_size()

func get_speed() -> int:
	var newSpeed := clampi(modifierHandler.get_modified_value(stats.speed, Modifier.Type.SPEED), 1, 10000)
	return newSpeed

func _on_spell_tag_active() -> void:
	spellTag = true

func _on_spell_tag_deactive() -> void:
	spellTag = false
