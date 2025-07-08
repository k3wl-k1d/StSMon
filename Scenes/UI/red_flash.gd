extends CanvasLayer

@onready var colorRect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

func _ready() -> void:
	Events.player_hit_without_block.connect(_on_player_hit)
	timer.timeout.connect(_on_timer_timeout)

func _on_player_hit() -> void:
	colorRect.color.a = 0.2
	timer.start()

func _on_timer_timeout() -> void:
	colorRect.color.a = 0.0
