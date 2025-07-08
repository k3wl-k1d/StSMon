class_name Tooltip
extends PanelContainer

@export var fadeSeconds := 0.2

@onready var tooltipIcon: TextureRect = %TooltipIcon
@onready var tooltipText: RichTextLabel = %TooltipText

var tween: Tween
var isVisible := false

func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.card_tooltip_hide.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	hide()

func show_tooltip(icon: Texture, text: String) -> void:
	isVisible = true
	if tween:
		tween.kill()
	
	tooltipIcon.texture = icon
	tooltipText.text = text
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fadeSeconds)

func hide_tooltip() -> void:
	isVisible = false
	if tween:
		tween.kill()
	
	get_tree().create_timer(fadeSeconds, false).timeout.connect(hide_animation)

func hide_animation() -> void:
	# Only play hide animation if tooltip is not visible
	if not isVisible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fadeSeconds)
		tween.tween_callback(hide)
