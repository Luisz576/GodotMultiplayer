extends Node

var gameController

func setup(GC):
	gameController = GC

func _process(_delta):
	#spawn
	if(Input.is_action_just_pressed("spawn_character")):
		gameController.useCard(gameController.getCardSelected())
	#numbers
	for i in Deck.DECK_SIZE:
		if(Input.is_action_just_pressed("number_" + str(i+1))):
			gameController.selectCard(i+1)
