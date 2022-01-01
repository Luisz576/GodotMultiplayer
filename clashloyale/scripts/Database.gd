extends Node

func _ready():
	deckSaver = Saver.new(DECK_SAVER_PATH)
	pass

#NUMBER OF MAPS
const MAPS_FOLDER_PATH = "res://sprites/maps/"

func getNumberOfMaps()->int:
	return getMapsPath().size()

func getMapsPath()->Array:
	return getPathsOfDir(MAPS_FOLDER_PATH)

#DECK
const DECK_SAVER_PATH = "deck.dat"

var deckSaver:Saver = null

func getDeck():
	var data = deckSaver.getData()
	var deck = null
	if data != null:
		deck = Deck.new()
		var i = 0
		for c in data["cards"]:
			var cm = CharacterMeta.new()
			cm.loadFromObject(c)
			deck.setCard(Card.new(cm), i)
			i += 1
	return deck

func saveDeck(deck:Deck):
	if deck == null:
		deckSaver.clear()
		return
	#TRATAR VALORES
	var deckToSave = {}
	var cards = []
	for card in deck.getCards():
		cards.append(card.getMeta().toObject() if card != null else null)
	deckToSave["cards"] = cards
	return deckSaver.save(deckToSave)

#DATABASE FUNCS SELF
func getPathsOfDir(folder)->Array:
	var paths = []
	var directory = Directory.new()
	directory.open(folder)
	directory.list_dir_begin()
	var filename = directory.get_next()
	while filename:
		if not directory.current_is_dir():
			paths.append((folder + "%s") % filename)
		filename = directory.get_next()
	return paths

func getFilesOfDir(folder)->Array:
	var files = []
	var directory = Directory.new()
	directory.open(folder)
	directory.list_dir_begin()
	var filename = directory.get_next()
	while filename:
		if not directory.current_is_dir():
			files.append(filename)
		filename = directory.get_next()
	return files

func _setupDefaultVarsIfIsTheFirstTime():
	#DECK DEFAULT
	print(getDeck())
	if getDeck() == null:
		saveDeck(Deck.new())
	pass
