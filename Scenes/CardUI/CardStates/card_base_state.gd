extends CardState

var mouseOverCard := false

func enter() -> void:
	if not cardUI.is_node_ready():
		await cardUI.ready
	
	if cardUI.tween and cardUI.tween.is_running():
		cardUI.tween.kill()
	
	cardUI.visuals.panel.set("theme_override_styles/panel", cardUI.visuals.baseStyleBox)
	cardUI.reparent_requested.emit(cardUI)
	cardUI.pivot_offset = Vector2.ZERO
	Events.card_tooltip_hide.emit()

func on_gui_input(event: InputEvent) -> void:
	if not cardUI.playable or cardUI.disabled:
		return
	
	if mouseOverCard and event.is_action_pressed("left_mouse"):
		cardUI.pivot_offset = cardUI.get_global_mouse_position() - cardUI.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	mouseOverCard = true
	if not cardUI.playable or cardUI.disabled:
		return
	
	cardUI.visuals.panel.set("theme_override_styles/panel", cardUI.visuals.hoverStyleBox)
	cardUI.request_tooltip()

func on_mouse_exited() -> void:
	mouseOverCard = false
	if not cardUI.playable or cardUI.disabled:
		return
	
	cardUI.visuals.panel.set("theme_override_styles/panel", cardUI.visuals.baseStyleBox)
	Events.card_tooltip_hide.emit()
