class_name RewardButton
extends Button

@export var rewardIcon: Texture: set = set_reward_icon
@export var rewardText: String: set = set_reward_text

@onready var customIcon: TextureRect = %CustomIcon
@onready var customText: Label = %CustomText

func set_reward_icon(value: Texture) -> void:
	rewardIcon = value
	if not is_node_ready():
		await ready
	
	customIcon.texture = rewardIcon

func set_reward_text(value: String) -> void:
	rewardText = value
	if not is_node_ready():
		await ready
	
	customText.text = rewardText

func _on_pressed() -> void:
	queue_free()
