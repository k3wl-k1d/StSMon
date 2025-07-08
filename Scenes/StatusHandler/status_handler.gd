class_name StatusHandler
extends GridContainer

signal statuses_applied(type: Status.Type)
signal status_call_finished

const STATUS_APPLY_INTERVAL := 0.25
const STATUS_UI := preload("res://Scenes/StatusHandler/status_ui.tscn")

@export var statusOwner: Entity

func apply_statuses_by_type(type: Status.Type) -> void:
	if not is_node_ready():
		await ready
	
	if type == Status.Type.EVENT_BASED:
		status_call_finished.emit()
		return
	
	var statusQueue: Array[Status] = _get_all_statuses().filter(
		func(status: Status):
			return status.type == type
	)
	if statusQueue.is_empty():
		statuses_applied.emit(type)
		status_call_finished.emit()
		return
	
	var tween := create_tween()
	for status: Status in statusQueue:
		tween.tween_callback(status.apply_status.bind(statusOwner))
		tween.tween_interval(STATUS_APPLY_INTERVAL)
	
	tween.finished.connect(func(): 
		statuses_applied.emit(type))

func add_status(status: Status) -> void:
	if not is_node_ready():
		await ready
	
	var stackable := status.stackType != Status.StackType.NONE
	
	# Add it if it's new
	if not _has_status(status.id):
		var newStatusUI := STATUS_UI.instantiate() as StatusUI
		add_child(newStatusUI)
		newStatusUI.status = status
		newStatusUI.status.status_applied.connect(_on_status_applied)
		newStatusUI.status.initialize_status(statusOwner)
		return
	
	# If it's unique and we already have it, we return
	if not status.canExpire and not stackable:
		return
	
	# If it's duration stackable, expand upon it
	if status.canExpire and status.stackType == Status.StackType.DURATION:
		_get_status(status.id).duration += status.duration
		return
	
	# If it's stackle, add to it
	if status.stackType == Status.StackType.INTENSITY:
		_get_status(status.id).stacks += status.stacks

func remove_status(id: String) -> void:
	if not _has_status(id):
		return
	
	for statusUI: StatusUI in get_children():
		if statusUI.status.id == id:
			statusUI.queue_free()
			return

func clear_statuses() -> void:
	for statusUI: StatusUI in get_children():
		statusUI.queue_free()

func _has_status(id: String) -> bool:
	for statusUI: StatusUI in get_children():
		if statusUI.status.id == id:
			return true
	
	return false

func _get_status(id: String) -> Status:
	for statusUI: StatusUI in get_children():
		if statusUI.status.id == id:
			return statusUI.status
	
	return null

func _get_all_statuses() -> Array[Status]:
	var statuses: Array[Status] = []
	for statusUI: StatusUI in get_children():
		statuses.append(statusUI.status)
	
	return statuses

func _on_status_applied(status: Status) -> void:
	if status.canExpire:
		status.duration -= 1


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and get_child_count() > 0:
		Events.status_tooltip_requested.emit(_get_all_statuses())
