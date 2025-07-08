class_name Shop
extends Control

const SHOP_CARD := preload("res://Scenes/Shop/shop_card.tscn")
const SHOP_RELIC := preload("res://Scenes/Shop/shop_relic.tscn")
const NORMAL_CARDS := preload("res://Character Attributes/Typings/Normal/normal_draftable_cards.tres")
const ROW1_NUM := 5
const ROW2_NUM := 5
const RELIC_NUM := 4

@export var shopRelics: Array[Relic]
@export var char1: CharacterStats
@export var char2: CharacterStats
@export var runStats: RunStats
@export var relicHandler: RelicHandler

@onready var cardsRow1: HBoxContainer = %Cards1
@onready var cardsRow2: HBoxContainer = %Cards2
@onready var relics: GridContainer = %Relics
@onready var animation: AnimationPlayer = %ShopkeeperAnimation
@onready var blinkTimer: Timer = %BlinkTimer
@onready var cardTooltip: CardTooltipPopup = %CardTooltipPopup
@onready var modifierHandler: ModifierHandler = $ModifierHandler

func _ready() -> void:
	for shopCard: ShopCard in cardsRow1.get_children():
		shopCard.queue_free()
	for shopCard: ShopCard in cardsRow2.get_children():
		shopCard.queue_free()
	for shopRelic: ShopRelic in relics.get_children():
		shopRelic.queue_free()
	
	Events.shop_card_bought.connect(_on_shop_card_bought)
	Events.shop_relic_bought.connect(_on_shop_relic_bought)
	
	_blink_timer_setup()
	blinkTimer.timeout.connect(_on_blink_timer_timeout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and cardTooltip.visible:
		cardTooltip.hide_tooltip()

func populate_shop() -> void:
	_generate_shop_cards()
	_generate_shop_relics()

func _blink_timer_setup() -> void:
	blinkTimer.wait_time = randf_range(1.0, 5.0)
	blinkTimer.start()

func _generate_shop_cards() -> void:
	var shopCards: Array[Card] = []
	# NOTE THIS CONTAINS DUPLICATES
	var availableCards: Array[Card] = char1.draftableCardsPrimaryType.duplicate_cards()
	availableCards.append_array(char1.draftableCardsSecondaryType.duplicate_cards())
	availableCards.append_array(char2.draftableCardsPrimaryType.duplicate_cards())
	availableCards.append_array(char2.draftableCardsSecondaryType.duplicate_cards())
	RNG.array_shuffle(availableCards)
	shopCards = availableCards.slice(0,ROW1_NUM)
	
	for card: Card in shopCards:
		var newShopCard := SHOP_CARD.instantiate() as ShopCard
		cardsRow1.add_child(newShopCard)
		newShopCard.card = card
		newShopCard.currentCardUI.tooltip_requested.connect(cardTooltip.show_tooltip)
		newShopCard.goldCost[card.rarity] = _get_updated_shop_cost(newShopCard.goldCost[card.rarity])
		newShopCard.update(runStats)
	
	var normalCards: Array[Card] = NORMAL_CARDS.duplicate_cards()
	shopCards.clear()
	shopCards = normalCards.slice(0,ROW2_NUM)
	
	for card: Card in shopCards:
		var newShopCard := SHOP_CARD.instantiate() as ShopCard
		cardsRow2.add_child(newShopCard)
		newShopCard.card = card
		newShopCard.currentCardUI.tooltip_requested.connect(cardTooltip.show_tooltip)
		newShopCard.goldCost[card.rarity] = _get_updated_shop_cost(newShopCard.goldCost[card.rarity])
		newShopCard.update(runStats)

func _generate_shop_relics() -> void:
	var shopRelicsArray: Array[Relic] = []
	var availableRelics := shopRelics.filter(
		func(relic: Relic):
			var canAppear := relic.can_appear_as_reward(char1, char2)
			var alreadyHadIt := relicHandler.has_relic(relic.id) and not relic.consumable
			return canAppear and not alreadyHadIt
	)
	
	RNG.array_shuffle(availableRelics)
	shopRelicsArray = availableRelics.slice(0,RELIC_NUM)
	
	for relic: Relic in shopRelicsArray:
		var newShopRelic := SHOP_RELIC.instantiate() as ShopRelic
		relics.add_child(newShopRelic)
		newShopRelic.relic = relic
		newShopRelic.goldCost = _get_updated_shop_cost(newShopRelic.goldCost)
		newShopRelic.update(runStats)

func update_items() -> void:
	for shopCard: ShopCard in cardsRow1.get_children():
		shopCard.update(runStats)
	for shopCard: ShopCard in cardsRow2.get_children():
		shopCard.update(runStats)
	for shopRelic: ShopRelic in relics.get_children():
		shopRelic.update(runStats)

func update_item_costs() -> void:
	for shopCard: ShopCard in cardsRow1.get_children():
		var goldCost = shopCard.goldCost[shopCard.card.rarity] as int
		shopCard.goldCost[shopCard.card.rarity] = _get_updated_shop_cost(goldCost)
		shopCard.update(runStats)
	
	for shopCard: ShopCard in cardsRow2.get_children():
		var goldCost = shopCard.goldCost[shopCard.card.rarity] as int
		shopCard.goldCost[shopCard.card.rarity] = _get_updated_shop_cost(goldCost)
		shopCard.update(runStats)
	
	for shopRelic: ShopRelic in relics.get_children():
		shopRelic.goldCost = _get_updated_shop_cost(shopRelic.goldCost)
		shopRelic.update(runStats)

func _get_updated_shop_cost(originalValue: int) -> int:
	return modifierHandler.get_modified_value(originalValue, Modifier.Type.SHOP_COST)

func _on_back_button_pressed() -> void:
	Events.shop_exited.emit()

func _on_shop_card_bought(card: Card, amount: int) -> void:
	PokemonTeam.deck.add_card(card)
	runStats.gold -= amount
	update_items()

func _on_shop_relic_bought(relic: Relic, amount: int) -> void:
	relicHandler.add_relic(relic)
	runStats.gold -= amount
	
	if relic is CouponsRelic:
		var couponsRelic := relic as CouponsRelic
		couponsRelic.add_shop_modifier(self)
		update_item_costs()
	else:
		update_items()

func _on_blink_timer_timeout() -> void:
	animation.play("blink")
	_blink_timer_setup()
