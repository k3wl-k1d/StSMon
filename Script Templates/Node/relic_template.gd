# meta-name: Relic
# meta-description: Create a Relic which can be aqcuired by the player
extends Relic

var memberVar := 0

func initialize_relic(_owner: RelicUI) -> void:
	print("This happens when you gain the relic")

func activate_relic(_owner: RelicUI) -> void:
	print("This happens specific times based on the Relic.Type")
	
func deactivate_relic(_owner: RelicUI) -> void:
	print("This is called when a RelicUI is exiting the Scene Tree (deleted)")
	print("Event-based relics should disconnect from Events here")

# Return unique tooltips if necessary
func get_tooltip() -> String:
	return tooltip
