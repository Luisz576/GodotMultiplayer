extends Control

#CARD
var cardIndexOnOriginalDeck = -1
var cardSaved:Card
var cardEditing:Card

#READY
func _ready():
	for camp in $properties_camps.get_children():
		for camp_camp in camp.get_children():
			if camp_camp is TextEdit:
				camp_camp.connect("text_changed", self, "_on_something_change")
	pass

#SET_TWO
func doEqualsSaveAndEditing(cardMeta:CharacterMeta):
	var newMetaEdit = CharacterMeta.new()
	newMetaEdit.loadFromObject(cardMeta.toObject())
	cardEditing = Card.new(newMetaEdit)
	var newMetaSave = CharacterMeta.new()
	newMetaSave.loadFromObject(cardMeta.toObject())
	cardSaved = Card.new(newMetaSave)
	pass

#EDIT
func setEditingCard(cardIndex:int):
	cardIndexOnOriginalDeck = cardIndex
	var cardMeta = Database.getDeck().getCard(cardIndexOnOriginalDeck).getMeta()
	doEqualsSaveAndEditing(cardMeta)
	_updateScreen()
	_resetCamps()
	pass

func hasChangeSomethingInCard()->bool:
	var editing = cardEditing.getMeta()
	var saved = cardSaved.getMeta()
	return !(editing.nome == saved.nome and
		editing.hair == saved.hair and
		editing.eyes == saved.eyes and
		editing.body == saved.body and
		editing.shirt == saved.shirt and
		editing.pants == saved.pants and
		editing.shoes == saved.shoes and
		editing.projectile == saved.projectile and
		editing.healthLevel == saved.healthLevel and
		editing.strengthLevel == saved.strengthLevel and
		editing.velocityLevel == saved.velocityLevel and
		editing.shootVelocityLevel == saved.shootVelocityLevel and
		editing.reachLevel == saved.reachLevel and
		editing.skill == saved.skill and
		editing.skillLevel == saved.skillLevel)

func _changeSomeCamp():
	$bt_save.disabled = !hasChangeSomethingInCard()
	pass

#CAMPS
func _getInfoOfCamps():
	cardEditing.meta.nome = $properties_camps/name_camp/edit_name.text
	pass

func _resetCamps():
	var saved = cardSaved.getMeta()
	$properties_camps/name_camp/edit_name.text = saved.nome
	_changeSomeCamp()
	pass

func _updateScreen():
	$CardBase.setCard(cardSaved)
	pass

#SIGNALS
func _on_bt_voltar_button_down():
	queue_free()
	return get_tree().change_scene("res://scenes/EditDeck.tscn")

func _on_bt_save_button_down():
	#SAVE
	var deck = Database.getDeck()
	var cards = deck.getCards()
	cards[cardIndexOnOriginalDeck] = cardEditing
	deck.setDeck(cards)
	Database.saveDeck(deck)
	doEqualsSaveAndEditing(cardEditing.getMeta())
	_updateScreen()
	_changeSomeCamp()
	pass

func _on_something_change():
	_getInfoOfCamps()
	_changeSomeCamp()
	pass
