# meta-name: Effect
# meta-description: Create an effect which can be applied to a target
class_name MyEffect
extends Effect

var memberVar := 0

func execute(targets: Array[Node]) -> void:
	print("My effect targets: %s" % targets)
	print("It does %s something" % memberVar)
