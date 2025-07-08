extends Relic

var healAmount := 0.25
var healThreshold := 0.5
var relicUI: RelicUI

func initialize_relic(owner: RelicUI) -> void:
	Events.player_hit_without_block.connect(_on_player_hit)
	relicUI = owner

func deactivate_relic(_owner: RelicUI) -> void:
	Events.player_hit_without_block.disconnect(_on_player_hit)

func _on_player_hit() -> void:
	var p1 := relicUI.get_tree().get_nodes_in_group("player")[0] as Player
	var p2 := relicUI.get_tree().get_nodes_in_group("player")[1] as Player
	var used := false
	
	if p1 and p1.stats.health < floori(p1.stats.maxHealth * healThreshold) and not PokemonTeam.fainted.has(p1):
		p1.stats.heal(ceili(p1.stats.maxHealth * healAmount))
		used = true
	if p2 and p2.stats.health < floori(p2.stats.maxHealth * healThreshold) and not PokemonTeam.fainted.has(p2):
		p2.stats.heal(ceili(p2.stats.maxHealth * healAmount))
		used = true
	if used:
		relicUI.flash()
		relicUI.relic.currentStacks -= 1
