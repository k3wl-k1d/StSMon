extends CardState

func enter() -> void:
	cardUI.drop_point_detector.monitoring = true
	cardUI.originalIndex = cardUI.get_index()

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
