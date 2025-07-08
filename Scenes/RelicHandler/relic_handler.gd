class_name RelicHandler
extends HBoxContainer

signal relics_activated(type: Relic.Type)

const RELIC_APPLY_INTERVAL := 0.5
const RELIC_UI := preload("res://Scenes/RelicHandler/relic_ui.tscn")

@onready var relicsControl: Control = $RelicsControl
@onready var relics: HBoxContainer = %Relics

func _ready() -> void:
	relics.child_exiting_tree.connect(_on_relics_exiting_tree)

func activate_relics_by_type(type: Relic.Type) -> void:
	if type == Relic.Type.EVENT_BASED:
		return
	var relicQueue: Array[RelicUI] = _get_all_relic_ui_nodes().filter(
		func(relicUI: RelicUI):
			return relicUI.relic.type == type
	)
	
	if relicQueue.is_empty():
		relics_activated.emit(type)
		return
	
	var tween := create_tween()
	var consumedRelics: Array[RelicUI] = []
	for relicUI: RelicUI in relicQueue:
		tween.tween_callback(func():
			relicUI.relic.activate_relic(relicUI)
			if relicUI.relic.consumable and relicUI.relic.currentStacks <= 0:
				consumedRelics.append(relicUI)
			relicUI.update_relic_ui()
			)
		
		tween.tween_interval(RELIC_APPLY_INTERVAL)
	
	tween.finished.connect(func():
		relics_activated.emit(type)
		for relicUI: RelicUI in consumedRelics:
			remove_relic(relicUI)
		)

func add_relics(relicsArray: Array[Relic]) -> void:
	for relic: Relic in relicsArray:
		add_relic(relic)

func add_relic(relic: Relic) -> void:
	if has_relic(relic.id) and not relic.consumable:
		return
	# Add stacks to relic if it is a consumable
	elif has_relic(relic.id) and relic.consumable:
		add_relic_stacks(relic.id, relic.baseStacks)
	else:
		var newRelic := RELIC_UI.instantiate() as RelicUI
		relics.add_child(newRelic)
		newRelic.relic = relic
		if newRelic.relic.baseStacks > 0:
			newRelic.relic.currentStacks = relic.baseStacks
		newRelic.relic.initialize_relic(newRelic)

func remove_relic(relicUI: RelicUI) -> void:
	if not has_relic(relicUI.relic.id):
		return
	
	for relic: RelicUI in relics.get_children():
		if relic == relicUI:
			relic.free()

func add_relic_stacks(id: String, amount: int) -> void:
	for relicUI: RelicUI in relics.get_children():
		if relicUI.relic.id == id:
			relicUI.relic.currentStacks += amount
			relicUI.update_relic_ui()

func has_relic(id: String) -> bool:
	for relicUI: RelicUI in relics.get_children():
		if relicUI.relic.id == id and is_instance_valid(relicUI):
			return true
	
	return false

func get_relic(id: String) -> Relic:
	var allRelics := get_all_relics()
	for relic: Relic in allRelics:
		if relic.id == id:
			return relic
	return null

func get_all_relics() -> Array[Relic]:
	var relicUINodes := _get_all_relic_ui_nodes()
	var relicsArray: Array[Relic] = []
	for relicUI: RelicUI in relicUINodes:
		relicsArray.append(relicUI.relic)
	
	return relicsArray

func _get_all_relic_ui_nodes() -> Array[RelicUI]:
	var allRelics: Array[RelicUI] = []
	for relicUI: RelicUI in relics.get_children():
		allRelics.append(relicUI)
	
	return allRelics

func _on_relics_exiting_tree(relicUI: RelicUI) -> void:
	if not relicUI:
		return
	
	if relicUI.relic:
		relicUI.relic.deactivate_relic(relicUI)
