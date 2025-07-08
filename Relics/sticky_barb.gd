extends Relic

var damage := 2

func activate_relic(owner: RelicUI) -> void:
	var enemies := owner.get_tree().get_nodes_in_group("enemies")
	var damageEffect := DamageEffect.new()
	damageEffect.amount = damage
	damageEffect.receiverModifierType = Modifier.Type.NO_MODIFIER
	damageEffect.execute(enemies)
	owner.flash()
