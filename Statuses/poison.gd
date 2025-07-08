class_name PoisonStatus
extends Status

const POISON_STATUS := preload("res://Statuses/poison.tres")

var poisonStacks := 0
var percentIncrease := 0.5

func initialize_status(_target: Node) -> void:
	Events.detonate_poison.connect(_on_poison_detonated)

func apply_status(target: Node) -> void:
	poisonStacks = target.statusHandler._get_status("poison").stacks
	var newPoisonStacks = ceili(poisonStacks * percentIncrease)
	var poison := POISON_STATUS.duplicate()
	poison.stacks = newPoisonStacks
	target.statusHandler.add_status(poison)
	
	status_applied.emit(self)

func _on_poison_detonated(target: Entity) -> void:
	if target.statusHandler._has_status("poison"):
		var poisonDamage = target.statusHandler._get_status("poison").stacks
		var damageEffect := DamageEffect.new()
		print("POISON detonated for ", poisonDamage)
		damageEffect.amount = poisonDamage
		damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
		damageEffect.execute([target])
		target.statusHandler.remove_status("poison")

func get_tooltip() -> String:
	return tooltip % stacks
