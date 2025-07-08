# meta-name: Event RoomMore actions
# meta-description: Create a custom room where something happens
class_name MyAwesomeEvent
extends EventRoom

@onready var exampleButton: EventRoomButton = %ExampleButton


func _ready() -> void:
	# You can use EventRoomButtons to create simple button behaviour.
	# These buttons automatically emit Events.event_room_exited when pressed.
	# However, you can pass an optional Callable that executes BEFORE that happens.
	exampleButton.event_button_callback = add_gold
	
	# If your EventRoom doesn't need buttons 
	# make sure to emit this signal when you're done with everything
	# Events.event_room_exited.emit()

# If you want to do something once, AFTER injecting the dependencies
# do it here.
func setup() -> void:
	pass

func add_gold() -> void:
	runStats.gold += 50
