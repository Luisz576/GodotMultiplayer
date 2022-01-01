extends Node

#COMPONENTS
export(NodePath) var charactersNodePath
onready var charactersNode = get_node(charactersNodePath)
onready var CharacterEmpty = preload("res://objects/components/Character.tscn")
export(Array, Vector2) var charactersSpawnsPosition = []

#vars
var gameController

func setup(GC):
	gameController = GC
	pass

func spawnCharacter(characterMeta:CharacterMeta, tId:int):
	if get_tree().is_network_server():
		rpc("_spawnCharacter", characterMeta.toObject(), tId)
	else:
		print("You can't really spawn a character!")
	pass

#remotesync
remotesync func _spawnCharacter(characterMetaObj, teamId):
	#BUILD THE META
	var cm = CharacterMeta.new()
	cm.loadFromObject(characterMetaObj)
	#SPAWN
	var character = CharacterEmpty.instance()
	character.setup(gameController, cm, teamId)
	character.name = cm.nome + "_" + str(teamId) + "_"
	charactersNode.call_deferred("add_child", character)
	character.position = charactersSpawnsPosition[teamId]
	character.set_network_master(gameController.getJogadorTeamNetworkMaster(teamId))
	pass
