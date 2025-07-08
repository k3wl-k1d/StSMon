extends VBoxContainer

@onready var turnOrderSegment := preload("res://Scenes/UI/turn_order_segment.tscn")

func _ready() -> void:
	Events.turn_order_changed.connect(update_turn_order_ui)

func update_turn_order_ui(currentEntity: Entity, entities: Array[Entity]) -> void:
	clear_turn_order()
	var currentTurnSegment: HBoxContainer = turnOrderSegment.instantiate()
	add_child(currentTurnSegment)
	currentTurnSegment.pokemonIcon.texture = currentEntity.stats.icon
	currentTurnSegment.pokemonName.text = currentEntity.stats.name
	currentTurnSegment.pokemonName.add_theme_color_override("font_color", Color.GOLDENROD)
	if currentEntity is Enemy and currentEntity.enemyActionPicker.target and "damage" in currentEntity.currentAction:
		currentTurnSegment.targetIcon.texture = currentEntity.enemyActionPicker.target.stats.baseIcon
	
	for entity in entities:
		var newTurnOrderSegment: HBoxContainer = turnOrderSegment.instantiate() as TurnOrderSegment
		add_child(newTurnOrderSegment)
		newTurnOrderSegment.pokemonIcon.texture = entity.stats.icon
		newTurnOrderSegment.pokemonName.text = entity.stats.name
		if entity is Enemy and entity.enemyActionPicker.target and "damage" in entity.currentAction and entity != currentEntity:
			newTurnOrderSegment.targetIcon.texture = entity.enemyActionPicker.target.stats.baseIcon

func clear_turn_order() -> void:
	var children := get_children()
	for child in children:
		remove_child(child)
