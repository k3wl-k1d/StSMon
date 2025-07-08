class_name CardUI
extends Control

const SIZE := Vector2(62, 76)
const BASE_STYLEBOX := preload("res://Scenes/CardUI/Styleboxes/Normal/normal_base_card_stylebox.tres")
const DRAG_STYLEBOX := preload("res://Scenes/CardUI/Styleboxes/Normal/normal_drag_card_stylebox.tres")
const HOVER_STYLEBOX := preload("res://Scenes/CardUI/Styleboxes/Normal/normal_hover_card_stylebox.tres")

signal reparent_requested(whichCardUI : CardUI)

@export var playerModifiers: ModifierHandler
@export var card: Card: set = _set_card
@export var charStats: CharacterStats : set = set_char_stats

# Proper variables
@onready var cardStateMachine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@onready var visuals: CardVisuals = $CardVisuals

var originalIndex := 0
var parent: Control
var tween: Tween
var playable := true : set = set_playable
var disabled := false
var crit := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_or_drag_started)
	Events.card_drag_started.connect(_on_card_aim_or_drag_started)
	Events.card_aim_ended.connect(_on_card_aim_or_drag_ended)
	Events.card_drag_ended.connect(_on_card_aim_or_drag_ended)
	Events.player_card_drawn.connect(_on_card_drawn)
	cardStateMachine.init(self)

func _input(event: InputEvent) -> void:
	cardStateMachine.on_input(event)

# Card arc while aiming
func animate_to_position(newPosition: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", newPosition, duration)

func play() -> void:
	if not card:
		return
	
	card.play(targets, charStats, playerModifiers)
	crit = PokemonTeam.critMeter == PokemonTeam.CRIT_CHARGE_MAX
	if crit:
		crit = false
		Events.reset_crit.emit()
		for i in targets.size():
			if targets[i] == null:
				targets.remove_at(i)
		card.play(targets, charStats, playerModifiers, false)
	
	queue_free()

func get_active_enemy_modifiers() -> ModifierHandler:
	if targets.is_empty() or targets.size() > 1 or not targets[0] is Enemy:
		return null
	
	return targets[0].modifierHandler

func request_tooltip() -> void:
	var enemyModifiers := get_active_enemy_modifiers()
	var updatedTooltip := card.get_updated_tooltip(playerModifiers, enemyModifiers)
	Events.card_tooltip_requested.emit(card.icon, updatedTooltip)

func _on_gui_input(event: InputEvent) -> void:
	cardStateMachine.on_gui_input(event)

func _on_mouse_entered() -> void:
	cardStateMachine.on_mouse_entered()
		
func _on_mouse_exited() -> void:
	cardStateMachine.on_mouse_exited()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	visuals.card = card

func set_playable(value: bool) -> void:
	playable = value
	if not playable:
		visuals.cost.add_theme_color_override("font_color", Color.RED)
		# Make transparent
		visuals.icon.modulate = Color(1,1,1,0.5)
	else:
		visuals.cost.remove_theme_color_override("font_color")
		# Revert transparency
		visuals.icon.modulate = Color(1,1,1,1)

func set_char_stats(value: CharacterStats) -> void:
	charStats = value
	charStats.stats_changed.connect(_on_char_stats_changed)

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _on_card_aim_or_drag_started(usedCard: CardUI) -> void:
	if usedCard == self:
		return
	disabled = true

func _on_card_aim_or_drag_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = charStats.can_play_card(card)

func _on_char_stats_changed() -> void:
	self.playable = charStats.can_play_card(card)

func _on_card_drawn(newCard: Card) -> void:
	if card == newCard:
		self.playable = charStats.can_play_card(newCard)
