extends KinematicBody2D

export(int) var VELOCITY_DEFAULT

var setuped = false

#PROPERTIES
var gameController = null
var meta:CharacterMeta = null
var mainTargetPosition = null

func getMeta()->CharacterMeta:
	return meta

func getNormalVelocity():
	if setuped and meta != null:
		return (meta.velocityLevel * VELOCITY_DEFAULT)
	return 0

#VARS
var life = 0
var attacking = false
var teamId = -1

#SETUP
func setup(GC, characterMeta:CharacterMeta, tId:int):
	gameController = GC
	meta = characterMeta
	teamId = tId
	mainTargetPosition = gameController.getTargetBasePosition(teamId)
	setuped = true
	pass

#PROCESS
func _process(_delta):
	if get_tree().is_network_server():
		if setuped:
			var directionToAttack = 1 if position.x < mainTargetPosition.x else -1
			#MOVE
			if !attacking:
				#moving
				# warning-ignore:return_value_discarded
				move_and_slide(Vector2(getNormalVelocity() * directionToAttack, 0))
				rpc_unreliable("_updatePosition", position)
	pass

#REMOTE
remote func _updatePosition(pos):
	position = pos
	pass
