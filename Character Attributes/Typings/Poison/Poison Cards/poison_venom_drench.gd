extends Card

const POISON_STATUS := preload("res://Statuses/poison.tres")
const VENOM_DRENCH_POWER := preload("res://Statuses/Powers/venom_drench_power.tres")

var poisonAmount := 6

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var statusEffect := StatusEffect.new()
	var poison := POISON_STATUS.duplicate()
	var venomDrench := VENOM_DRENCH_POWER.duplicate()
	poison.stacks = poisonAmount
	statusEffect.status = poison
	statusEffect.execute(targets)
	statusEffect.status = venomDrench
	statusEffect.execute(targets)
	SFXPlayer.play(sound)
