class_name BattleRewards
extends Control

const CARD_REWARDS := preload("res://Scenes/UI/card_rewards.tscn")
const REWARD_BUTTON := preload("res://Scenes/UI/reward_button.tscn")
const GOLD_ICON := preload("res://art/gold.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://art/rarity.png")
const CARD_TEXT := "Claim a new card"

@export var runStats: RunStats
@export var charStatsP1: CharacterStats
@export var charStatsP2: CharacterStats
@export var relicHandler: RelicHandler

@onready var rewards: VBoxContainer = %Rewards

var cardRewardTotalWeight := 0.0
var cardRarityWeights := {
	Card.Rarity.COMMON: 0.0,
	Card.Rarity.RARE: 0.0,
	Card.Rarity.MYTHICAL: 0.0
}

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()

func add_gold_reward(amount: int) -> void:
	var goldReward := REWARD_BUTTON.instantiate() as RewardButton
	goldReward.rewardIcon = GOLD_ICON
	goldReward.rewardText = GOLD_TEXT % amount
	goldReward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(goldReward)

func add_card_reward() -> void:
	var cardReward := REWARD_BUTTON.instantiate() as RewardButton
	cardReward.rewardIcon = CARD_ICON
	cardReward.rewardText = CARD_TEXT
	cardReward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(cardReward)

func add_relic_reward(relic: Relic) -> void:
	if not relic:
		return
	
	var relicReward := REWARD_BUTTON.instantiate() as RewardButton
	relicReward.rewardIcon = relic.icon
	relicReward.rewardText = relic.relicName
	relicReward.pressed.connect(_on_relic_reward_taken.bind(relic))
	rewards.add_child.call_deferred(relicReward)

func _show_card_rewards() -> void:
	if not runStats or not charStatsP1 or not charStatsP2:
		return
	
	var cardRewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(cardRewards)
	cardRewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var cardRewardArray: Array[Card] = []
	# NOTE THIS CONTAINS DUPLICATES
	var availableCards: Array[Card] = charStatsP1.draftableCardsPrimaryType.duplicate_cards()
	availableCards.append_array(charStatsP1.draftableCardsSecondaryType.duplicate_cards())
	availableCards.append_array(charStatsP2.draftableCardsPrimaryType.duplicate_cards())
	availableCards.append_array(charStatsP2.draftableCardsSecondaryType.duplicate_cards())
	
	for i in runStats.cardRewards:
		_setup_card_chances()
		var roll := RNG.instance.randf_range(0.0, cardRewardTotalWeight)
		
		for rarity: Card.Rarity in cardRarityWeights:
			if cardRarityWeights[rarity] > roll:
				_modify_weights(rarity)
				var pickedCard := _get_random_available_card(availableCards, rarity)
				cardRewardArray.append(pickedCard)
				availableCards.erase(pickedCard)
				break
	cardRewards.rewards = cardRewardArray
	cardRewards.show()

func _setup_card_chances() -> void:
	cardRewardTotalWeight = runStats.commonWeight + runStats.rareWeight + runStats.mythicalWeight
	cardRarityWeights[Card.Rarity.COMMON] = runStats.commonWeight
	cardRarityWeights[Card.Rarity.RARE] = runStats.commonWeight + runStats.rareWeight
	cardRarityWeights[Card.Rarity.MYTHICAL] = cardRewardTotalWeight

func _modify_weights(rarityRolled: Card.Rarity) -> void:
	if rarityRolled == Card.Rarity.MYTHICAL:
		runStats.mythicalWeight = RunStats.BASE_MYTHICAL_WEIGHT
	else:
		runStats.mythicalWeight = clampf(runStats.mythicalWeight + 0.3, runStats.BASE_MYTHICAL_WEIGHT, 5.0)

func _get_random_available_card(availableCards: Array[Card], withRarity: Card.Rarity) -> Card:
	var allPossibleCards := availableCards.filter(
		func(card: Card):
			return card.rarity == withRarity
	)
	return RNG.array_pick_random(allPossibleCards)

func _on_gold_reward_taken(amount: int) -> void:
	if not runStats:
		return
	
	runStats.gold += amount

func _on_card_reward_taken(card: Card) -> void:
	if not charStatsP1 or not charStatsP2 or not card:
		return
	
	PokemonTeam.deck.add_card(card)

func _on_relic_reward_taken(relic: Relic) -> void:
	if not relic or not relicHandler:
		return
	
	relicHandler.add_relic(relic)

func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
