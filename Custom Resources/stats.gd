class_name Stats
extends Resource

signal stats_changed

@export var name: String
@export var maxHealth := 1: set = set_max_health
@export var entitySpeed := 1
@export var battleStartStatuses: Array[Status]
@export var animation: SpriteFrames
@export var icon: Texture

var health: int: set = set_health
var block: int: set = set_block
var speed: int: set = set_speed

func set_health(value: int) -> void:
	health = clampi(value, 0, maxHealth)
	stats_changed.emit()

func set_block(value: int) -> void:
	block = clampi(value, 0, 999)
	stats_changed.emit()

func set_speed(value: int) -> void:
	speed = clampi(value, 1, 10000)
	stats_changed.emit()

func set_max_health(value : int) -> void:
	var diff := value - maxHealth
	maxHealth = value
	
	if diff > 0:
		health += diff
	elif health > maxHealth:
		health = maxHealth
	
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	
	var initialDamage = damage
	# Subtract damage from the block
	damage = clampi(damage-block, 0, damage)
	self.block = clampi(block - initialDamage, 0, block)
	self.health -= damage

func get_take_damage_difference(damage: int) -> int:
	# If you get a value that's weirdly high, it's because you did an oopsie
	if damage <= 0 or self.block < 0:
		return 888
	
	var initialDamage = damage
	initialDamage -= self.block
	
	return self.health - initialDamage

func heal(amount: int) -> void:
	self.health += amount

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = maxHealth
	instance.block = 0
	instance.speed = entitySpeed
	instance.icon = icon
	instance.name = name
	return instance
