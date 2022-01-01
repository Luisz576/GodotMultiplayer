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
				camp_camp.connect("text_changed", self, "_on_text_change")
			if camp_camp is OptionButton:
				camp_camp.connect("item_selected", self, "_on_dropbutton_change")

#SET_TWO
func doEqualsSaveAndEditing(cardMeta:CharacterMeta):
	var newMetaEdit = CharacterMeta.new()
	newMetaEdit.loadFromObject(cardMeta.toObject())
	cardEditing = Card.new(newMetaEdit)
	var newMetaSave = CharacterMeta.new()
	newMetaSave.loadFromObject(cardMeta.toObject())
	cardSaved = Card.new(newMetaSave)

#EDIT
func setEditingCard(cardIndex:int):
	_buildCamps()
	cardIndexOnOriginalDeck = cardIndex
	var cardMeta = Database.getDeck().getCard(cardIndexOnOriginalDeck).getMeta()
	doEqualsSaveAndEditing(cardMeta)
	_updateScreen()
	_resetCamps()

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

#CAMPS
func _getInfoOfCamps():
	cardEditing.meta.nome = $properties_camps/name_camp/edit_name.text
	if $properties_camps/hair_camp/edit_hair.selected > -1:
		cardEditing.meta.hair = $properties_camps/hair_camp/edit_hair.selected

func _resetCamps():
	var saved = cardSaved.getMeta()
	$properties_camps/name_camp/edit_name.text = saved.nome
	$properties_camps/hair_camp/edit_hair.select(saved.hair)
	_changeSomeCamp()

func _updateScreen():
	$CardBase.setCard(cardEditing)

func _buildCamps():
	for file in Database.getFilesOfDir(Card.HAIR_PATH):
		if file.ends_with(".png"):
			file = file.replace(".png", "")
			$properties_camps/hair_camp/edit_hair.add_item(file)

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

func _on_dropbutton_change(_index):
	_getInfoOfCamps()
	_updateScreen()
	_changeSomeCamp()

func _on_text_change():
	_getInfoOfCamps()
	_updateScreen()
	_changeSomeCamp()
