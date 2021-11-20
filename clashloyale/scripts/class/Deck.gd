extends Node
class_name Deck

const DECK_SIZE = 8

var deck = []

func _init():
	for _i in range(DECK_SIZE):
		deck.append(Card.new(CharacterMeta.new()))
	pass

func setDeck(newDeck:Array):
	var realNewDeck = []
	if newDeck.size() == DECK_SIZE:
		realNewDeck = newDeck
	else:
		for i in range(DECK_SIZE):
			if i < newDeck.size():
				realNewDeck.append(newDeck[i])
			else:
				realNewDeck = Card.new(CharacterMeta.new())
	deck = realNewDeck
	pass

func setCard(card:Card, position:int):
	position = position if position >= -1 and position < DECK_SIZE else -1
	if position >= 0:
		deck[position] = card
		return true
	return false

func getCard(position):
	return deck[position]

func getCards():
	return deck

func removeCard(position):
	deck[position] = null
	pass
