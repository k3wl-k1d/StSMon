extends Node2D

const ARC_POINTS := 8

@onready var area2D: Area2D = $Area2D
@onready var cardArc: Line2D = $CanvasLayer/CardArc

var currentCard: CardUI
var targeting := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)

func _process(_delta: float) -> void:
	if not targeting:
		return
	area2D.position = get_global_mouse_position()
	cardArc.points = _get_points()

# Get points for the aiming curve
func _get_points() -> Array:
	var points := []
	var start := currentCard.global_position
	start.x += (currentCard.size.x / 2)
	var target := get_local_mouse_position()
	var distance := (target-start)
	
	# Appends points along the vector to the points array
	for i in range(ARC_POINTS):
		var t := (1.0 /ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	
	points.append(target)
	return points

# Turns a straight line into a curve
func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3)

func _on_card_aim_started(card : CardUI) -> void:
	if not card.card.is_single_targeted():
		return
	
	targeting = true
	area2D.monitoring = true
	area2D.monitorable = true
	currentCard = card

func _on_card_aim_ended(_card : CardUI) -> void:
	targeting = false
	cardArc.clear_points()
	area2D.position = Vector2.ZERO
	area2D.monitoring = false
	area2D.monitorable = false
	currentCard = null

func _on_area_2d_area_entered(area : Area2D) -> void:
	if not currentCard or not targeting:
		return
	
	# Append area 2D to valid targets
	if not currentCard.targets.has(area):
		currentCard.targets.append(area)
		currentCard.request_tooltip()

func _on_area_2d_area_exited(area : Area2D) -> void:
	if not currentCard or not targeting:
		return
	
	# Erase the area from valid targets
	currentCard.targets.erase(area)
	currentCard.request_tooltip()
