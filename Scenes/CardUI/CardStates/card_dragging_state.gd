extends CardState

const DRAG_MINIMUM := 0.05
var minimum_drag_elapsed := false

func enter() -> void:
	var ui_layer: = get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		cardUI.reparent(ui_layer)
	
	cardUI.visuals.panel.set("theme_override_styles/panel", cardUI.visuals.dragStyleBox)
	Events.card_drag_started.emit(cardUI)
	# Ensure that click and release mouse cannot occur at the same time
	minimum_drag_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM, false)
	threshold_timer.timeout.connect(func(): minimum_drag_elapsed = true)

func exit() -> void:
	Events.card_drag_ended.emit(cardUI)

func on_input(event: InputEvent) -> void:
	var singleTargeted := cardUI.card.is_single_targeted()
	var mouse_motion: = event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if singleTargeted and mouse_motion and cardUI.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if mouse_motion:
		cardUI.global_position = cardUI.get_global_mouse_position() - cardUI.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
