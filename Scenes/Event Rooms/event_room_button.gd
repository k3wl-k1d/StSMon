class_name EventRoomButton
extends Button

var eventButtonCallback: Callable


func _on_pressed() -> void:
	if eventButtonCallback:
		eventButtonCallback.call()
	
	#Events.event_room_exited.emit()
