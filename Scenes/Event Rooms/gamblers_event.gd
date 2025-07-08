extends EventRoom

@onready var label: Label = %Label
@onready var redButton: EventRoomButton = %BetOnRed
@onready var blackButton: EventRoomButton = %BetOnBlack
@onready var leaveButton: EventRoomButton = %Leave

func setup() -> void:
	redButton.disabled = runStats.gold < 50
	blackButton.disabled = runStats.gold < 50
	
	redButton.eventButtonCallback = bet_red
	blackButton.eventButtonCallback = bet_black
	leaveButton.eventButtonCallback = leave

func bet_black() -> void:
	blackButton.disabled = true
	redButton.disabled = true
	runStats.gold -= 50
	
	if RNG.instance.randf() < 0.3:
		label.text = "\"Congratultions! Such a lucky oaf, aren't we?\"\nThe voice shouts from above.\n\nYou revel in your earnings. A whole\n$200 richer..."
		runStats.gold += 200
	else:
		label.text = "\"Poor shmuck! Red might be your lucky colour, hm?\"\nThe voice sneers from above.\n\nYou feel your pockets lightening\nas your hard-earned gold disappears..."

func bet_red() -> void:
	redButton.disabled = true
	blackButton.disabled = true
	runStats.gold -= 50
	
	if RNG.instance.randf() < 0.5:
		label.text = "\"Congratultions! Safe and sound, huh?\"\nThe voice shouts from above.\n\nYou revel in your new $100,\nthough you salivate at what could have been."
		runStats.gold += 100
	else:
		label.text = "\"Poor shmuck! Should've gone harder, right?\"\nThe voice sneers from above.\n\nYou feel your pockets lightening\nas your hard-earned gold disappears..."
