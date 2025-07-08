extends Node

func shake(thing: Node2D, strength: float, duration: float = 0.2) -> void:
	if not thing:
		return
	var originalPosition := thing.position
	var shakeCount := 10
	var tween := create_tween()
	
	for i in shakeCount:
		var shakeOffset := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target := originalPosition + strength * shakeOffset
		if i % 2 == 0:
			target = originalPosition
		tween.tween_property(thing, "position", target, duration / float(shakeCount))
		strength *= 0.75
	
	tween.finished.connect(func():
		if not thing: return
		thing.position = originalPosition)
