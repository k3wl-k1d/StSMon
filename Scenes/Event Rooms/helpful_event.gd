class_name HelpfulBoiEvent
extends EventRoom

@onready var label: Label = %Label
@onready var duplicateButton: EventRoomButton = %DuplicateCard
@onready var plusMaxHPButton: EventRoomButton = %IncreaseMaxHealth
@onready var leaveButton: EventRoomButton = %Leave

func _ready() -> void:	
	duplicateButton.eventButtonCallback = duplicate_random_card
	plusMaxHPButton.eventButtonCallback = plus_max_hp
	leaveButton.eventButtonCallback = leave

func duplicate_random_card() -> void:
	duplicateButton.disabled = true
	plusMaxHPButton.disabled = true
	var newCard = PokemonTeam.deck.cards[RNG.instance.randi_range(0, PokemonTeam.deck.cards.size()-1)] as Card
	PokemonTeam.deck.add_card(newCard.duplicate())
	label.text = "\"Hmm... Yes! The perfect card for you!\"\n\nThe hooded figure hands\nthe team a %s and scurries away..." % newCard.cardName
	leaveButton.text = "Leave"

func plus_max_hp() -> void:
	duplicateButton.disabled = true
	plusMaxHPButton.disabled = true
	var teammateNum := RNG.instance.randi_range(0,1)
	var tempMember := characterStatsP1
	if teammateNum == 0:
		tempMember = characterStatsP2
	tempMember.maxHealth += 5
	label.text = "\"Feel healthy! Win healthy!\"\n\nThe hooded figure shouts as magic rays shoot from its fingers.\nYour team feels stronger."
	leaveButton.text = "Leave"
