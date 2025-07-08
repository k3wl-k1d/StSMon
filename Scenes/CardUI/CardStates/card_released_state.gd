extends CardState

var played: bool

func enter() -> void:
	played = false
	# Drop card into a valid area 2D target
	if not cardUI.targets.is_empty():
		played = true
		Events.card_tooltip_hide.emit()
		print("Card Released!!!")
		cardUI.play()

func post_enter() -> void:
	transition_requested.emit(self, CardState.State.BASE)
