extends Control

#CONTS
const CARD_HEIGHT = 220
const CARD_WIDTH = 200
const MAX_CARDS_BY_LINE = 4
const MARGINS_CARD = 40

#COMPONENTS
onready var EditCardScrene = preload("res://scenes/EditCard.tscn")
onready var CardBase = preload("res://objects/components/CardBase.tscn")

#DECK
var deck:Deck = null

func _ready():
	_updateCards()
	pass

func _updateCards():
	deck = Database.getDeck()
	#REMOVE
	for c in $cards.get_children():
		c.queue_free()
	#ADD AND SET
	for i in range(deck.DECK_SIZE):
		var newCard = CardBase.instance()
		newCard.setCard(deck.getCard(i))
		$cards.add_child(newCard)
		newCard.set_position(_calculateCardPosition(i))
		newCard.connect("onClick", self, "_on_card_click", [i])
	pass

func _calculateCardPosition(cardIndex:int)->Vector2:
	# warning-ignore:integer_division
	var line = int(cardIndex / MAX_CARDS_BY_LINE)
	var column = cardIndex % MAX_CARDS_BY_LINE
	var posX = MARGINS_CARD + (column * CARD_WIDTH) + (MARGINS_CARD * column)
	var posY = MARGINS_CARD + (line * CARD_HEIGHT) + (MARGINS_CARD * line)
	return Vector2(posX, posY)

#SIGNALS
func _on_bt_voltar_button_down():
	return get_tree().change_scene("res://scenes/MainMenu.tscn")

func _on_card_click(cardIndex):
	var scene = EditCardScrene.instance()
	get_parent().call_deferred("add_child", scene)
	scene.setEditingCard(cardIndex)
	queue_free()
	pass
