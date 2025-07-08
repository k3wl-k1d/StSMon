class_name CardStateMachine
extends Node

@export var initialState: CardState
var currentState: CardState
# Dictionary of existing states
var states: ={}

# Initialize dictionary of states
func init(card: CardUI) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.cardUI = card
	if initialState:
		initialState.enter()
		currentState = initialState


func on_input(event: InputEvent) -> void:
	if currentState:
		currentState.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if currentState:
		currentState.on_gui_input(event)

func on_mouse_entered() -> void:
	if currentState:
		currentState.on_mouse_entered()
		
func on_mouse_exited() -> void:
	if currentState:
		currentState.on_mouse_exited()


func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	# Check if from == curentState
	if from != currentState:
		return
	
	var newState: CardState = states[to]
	if not newState:
		return
	
	if currentState:
		currentState.exit()
	newState.enter()
	currentState = newState
	newState.post_enter()
