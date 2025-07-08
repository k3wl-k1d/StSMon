class_name CardPile
extends Resource

signal card_pile_size_changed(cardsAmount: int)

@export var cards: Array[Card] = []

func empty() -> bool:
	return cards.is_empty()

# We need this method because of a deep duplicate bug
# found here: https://github.com/godotengine/godot/issues/74918
func duplicate_cards() -> Array[Card]:
	var newArray: Array[Card] = []
	
	for card: Card in cards:
		newArray.append(card.duplicate())
	
	return newArray

# We need this method because of a deep duplicate bug
# found here: https://github.com/godotengine/godot/issues/74918
func custom_duplicate() -> CardPile:
	var newCardPile := CardPile.new()
	newCardPile.cards = duplicate_cards()
	
	return newCardPile

func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

func add_card(card: Card) -> void:
	cards.append(card)
	card_pile_size_changed.emit(cards.size())

func merge_decks(cardPile: CardPile) -> void:
	cards.append_array(get_card_pile_as_array(cardPile))
	card_pile_size_changed.emit(cards.size())

func shuffle() -> void:
	RNG.array_shuffle(cards)

func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())

func get_card_pile_as_array(cardPile: CardPile) -> Array[Card]:
	return cardPile.cards

func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[i].id])
	return "\n".join(_card_strings)
