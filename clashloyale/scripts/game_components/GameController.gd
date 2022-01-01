extends Node

enum GameState { STARTING, GAMEPLAY, FINISHING }

const DEFAULT_TIMER = 60 * 5
const MAX_PLAYERS = 2
const INITIAL_ELIXIR = 5
const GENERATE_ELIXIR_TIME = 2

#COMPONENTS
export(NodePath) var hudGame_path
var hudGame
export(NodePath) var characterController_path
var characterController
export(NodePath) var keyboardController_path
var keyboardController
export(Array, Vector2) var basePositions

#GAME VARS
var gameState = GameState.STARTING
var timer = 0
var timerRunning = false
var teamInfo = []
#TEAM INFO
	#0
		#target
		#jogadores
		#base_position
		#players_elixir_index

#PLAYER VARS
var playerDeck:Deck = null
var playerDeckCardSelectedIndex = 0
var playersElixir = []

#READY
func _ready():
	randomize()
	if _setupGame():
		startGame()
	pass

#PROCESS
func _process(_delta):
	match gameState:
		GameState.GAMEPLAY:
			hudGame._updateHud()
			pass
		GameState.FINISHING:
			pass
	pass

#UTILS FUNC
func getTeamIndexOfJogadorConnectionId(jogadorConnectionId):
	for i in range(teamInfo.size()):
		if teamInfo[i]["jogadores"].has(jogadorConnectionId):
			return i
	return -1

func getTeamInfo(teamId):
	if teamId > -1 and teamId < teamInfo.size():
		return teamInfo[teamId]
	return null

func getJogadorTeamNetworkMaster(teamId):
	var team = getTeamInfo(teamId)
	if team != null:
		return team["jogadores"][0]
	return -1

func getTeamInfoByJogadorConnectionId(jogadorConnectionId):
	for i in range(teamInfo.size()):
		if teamInfo[i]["jogadores"].has(jogadorConnectionId):
			return teamInfo[i]
	return null

func getTargetBasePosition(teamId):
	var team = getTeamInfo(teamId)
	if team != null:
		var teamTarget = getTeamInfoByJogadorConnectionId(team["target"])
		if teamTarget != null:
			return teamTarget["base_position"]
	return null

func isJogadorOfTeam(jogadorConnectionId, teamId):
	if teamId > -1 and teamId < teamInfo.size():
		return teamInfo[teamId]["jogadores"].has(jogadorConnectionId)
	return false

func getCardSelected():
	return playerDeck.getCard(playerDeckCardSelectedIndex)

#UPDATES AND FUNCS
func updateTeamInfo():
	if get_tree().is_network_server():
		rpc("_updateTeamInfo", teamInfo)
	pass

func updateElixirs():
	if get_tree().is_network_server():
		rpc("_setElixir", playersElixir)
	pass

func useCard(card:Card):
	if get_tree().is_network_server():
		_spawnCharacter(card.getMeta().toObject(), Networking.getConnectionId())
	else:
		rpc("_spawnCharacter", card.getMeta().toObject(), Networking.getConnectionId())
	pass

func selectCard(index:int):
	playerDeckCardSelectedIndex = index

#GAME FUNCS
func _setupGame():
	var listaJogadores = Networking.getJogadores()
	#HUD
	hudGame = get_node(hudGame_path)
	if hudGame == null:
		rpc("_errorWhileLoadingGame", "Get HUD has falled!")
		return false
	hudGame.setup(self, MAX_PLAYERS)
	#CharacterController
	characterController = get_node(characterController_path)
	if characterController == null:
		rpc("_errorWhileLoadingGame", "Get CharacterController has falled!")
		return false
	characterController.setup(self)
	keyboardController = get_node(keyboardController_path)
	if keyboardController == null:
		rpc("_errorWhileLoadingGame", "Get KeyboardController has falled!")
		return false
	keyboardController.setup(self)
	#DECK
	playerDeck = Database.getDeck()
	#SERVER
	if get_tree().is_network_server():
		#TEAM INFO
		var elixirIndexCounter = 0
		for i in range(listaJogadores.size()):
			teamInfo.append({
				"target": null,
				"jogadores": [listaJogadores[i]],
				"base_position": Vector2.ZERO if basePositions.size() <= i else basePositions[i],
				"players_elixir_index": elixirIndexCounter
			})
			#ELIXIR
			playersElixir.append(INITIAL_ELIXIR)
			elixirIndexCounter += 1
		updateElixirs()
		for i in range(teamInfo.size()):
			for ij in range(listaJogadores.size()):
				if !isJogadorOfTeam(listaJogadores[ij], i):
					teamInfo[i]["target"] = listaJogadores[ij]
		updateTeamInfo()
		#MAPS
		var numberOfMaps = Database.getNumberOfMaps()
		if numberOfMaps > 0:
			rpc("_buildMap", Database.getMapsPath()[(randi() % numberOfMaps)])
		else:
			rpc("_errorWhileLoadingGame", "No map registered!")
			return false
	return true

func startGame():
	if gameState == GameState.STARTING and get_tree().is_network_server():
		rpc("_startGame")
	else:
		print("You can't start the game")

#SIGNALS
func _on_GameTimer_timeout():
	if get_tree().is_network_server():
		if timerRunning:
			if timer > 0:
				timer -= 1
				#UPDATE ELIXIR
				if timer % GENERATE_ELIXIR_TIME == 0:
					for i in range(playersElixir.size()):
						playersElixir[i] = playersElixir[i] + 1
					rpc("_setElixir", playersElixir)
		rpc("_setTimer", timer)
	pass

#REMOTESYNC FUNCS
remotesync func _errorWhileLoadingGame(reason):
	print("Can't load the game: " + reason)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	pass

remotesync func _buildMap(mapPath):
	print("TODO: BuildMap(" + str(mapPath) + ")")
	pass

remotesync func _startGame():
	timer = DEFAULT_TIMER
	timerRunning = true
	gameState = GameState.GAMEPLAY
	print("Jogo iniciado")
	pass

#REMOTE FUNCS
remote func _updateTeamInfo(tInfo):
	teamInfo = tInfo
	pass

remote func _setTimer(time):
	timer = time
	pass

remote func _setElixir(elixirs):
	playersElixir = elixirs
	pass

#SPAWN CHARACTER FUNCS
remote func _spawnCharacter(characterMetaObj, jogadorId):
	if get_tree().is_network_server():
		#CARD
		var c = CharacterMeta.new()
		c.loadFromObject(characterMetaObj)
		var card = Card.new(c)
		#TEAM
		var teamInfoIndex = getTeamIndexOfJogadorConnectionId(jogadorId)
		var teamOfSpawner = getTeamInfo(teamInfoIndex)
		if teamOfSpawner != null:
			var jogadorElixirIndex = teamOfSpawner["players_elixir_index"]
			if playersElixir[jogadorElixirIndex] >= card.cost:
				playersElixir[jogadorElixirIndex] -= card.cost
				updateElixirs()
				characterController.spawnCharacter(c, teamInfoIndex)
			else:
				rpc_id(jogadorId, "_failedToSpawnCharacter", "You havent the money to do that!")
		else:
			rpc_id(jogadorId, "_failedToSpawnCharacter", "Error getting Team!")
	pass

remotesync func _failedToSpawnCharacter(reason):
	print("Failed to spawn character: " + reason)
	hudGame.showMessage(reason)
	pass
#########
