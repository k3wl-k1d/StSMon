extends EnemyAction

const WEBBED_STATUS := preload("res://Statuses/webbed.tres")

@export var webbedDuration := 2

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var statusEffect := StatusEffect.new()
	var webbed := WEBBED_STATUS.duplicate()
	webbed.duration = webbedDuration
	statusEffect.status = webbed
	statusEffect.sound = sound
	statusEffect.execute(PokemonTeam.players)
	SFXPlayer.play(sound)
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
