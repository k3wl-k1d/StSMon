class_name StatusName
extends Status

var memberVar := 0

func initialize_status(target: Node) -> void:
	print("Initialize status for target %s " % target)

func apply_status(target: Node) -> void:
	print("My target is %s" % target)
	print("It does %s something" % memberVar)
	
	status_applied.emit(self)
