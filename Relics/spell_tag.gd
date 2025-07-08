extends Relic

const MALEDICTION := preload("res://Statuses/the_tags_malediction.tres")
const CURSE_STATUS := preload("res://Statuses/curse.tres")

func activate_relic(_owner: RelicUI) -> void:
	Events.spell_tag_activated.emit()
	
	if not Events.enemy_hit_without_block.is_connected(_on_curse_request):
		Events.enemy_hit_without_block.connect(_on_curse_request)
	
	var team := PokemonTeam.players
	var statusEffect := StatusEffect.new()
	var malediction := MALEDICTION.duplicate()
	statusEffect.status = malediction
	for member: Player in team:
		statusEffect.execute([member])
	
func deactivate_relic(_owner: RelicUI) -> void:
	Events.spell_tag_deactivated.emit()
	Events.enemy_hit_without_block.disconnect(_on_curse_request)

func _on_curse_request(enemy: Enemy, amount: int) -> void:
	var statusEffect := StatusEffect.new()
	var curse := CURSE_STATUS.duplicate()
	curse.stacks = amount
	statusEffect.status = curse
	statusEffect.execute([enemy])

# Return unique tooltips if necessary
func get_tooltip() -> String:
	return tooltip
