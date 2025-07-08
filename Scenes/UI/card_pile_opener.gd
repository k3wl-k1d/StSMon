class_name CardPileOpener
extends TextureButton

@export var counter: Label
@export var cardPile: CardPile: set = set_card_pile

func set_card_pile(value: CardPile) -> void:
	cardPile = value
	
	if not cardPile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		cardPile.card_pile_size_changed.connect(_on_card_pile_size_changed)
		_on_card_pile_size_changed(cardPile.cards.size())

func _on_card_pile_size_changed(cardsAmount: int) -> void:
	counter.text = str(cardsAmount)
