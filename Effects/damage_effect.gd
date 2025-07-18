class_name DamageEffect
extends Effect

# Damage amount to be dealt
var amount := 0
var receiverModifierType := Modifier.Type.DMG_TAKEN

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount, receiverModifierType)
			SFXPlayer.play(sound)
