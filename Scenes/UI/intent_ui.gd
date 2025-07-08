class_name IntentUI
extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

func update_intent(intent: Intent) -> void:
	if not intent:
		hide()
		return
	
	icon.texture = intent.icon
	icon.visible = icon.texture != null
	label.text = str(intent.currentText)
	label.visible = intent.currentText.length() > 0
	show()
