extends Node
class_name Card

var meta:CharacterMeta = null
var cost = 0

func _init(characterMeta:CharacterMeta):
	meta = characterMeta
	calculatePrice()
	pass

func calculatePrice():
	cost = _calculate()
	pass

func _calculate()->int:
	var c = 0
	c += meta.healthLevel
	c += meta.strengthLevel
	c += meta.velocityLevel
	c += meta.shootVelocityLevel# * 2
	c += meta.reachLevel# * 3
	if meta.skill != CharacterMeta.Skills.NONE:
		c += meta.skillLevel
	return c

func getCost()->int:
	return cost

func getMeta()->CharacterMeta:
	return meta

#PATHS

const HAIR_PATH = "res://sprites/characters/hair/"
const EYES_PATH = "res://sprites/characters/eyes/"
const BODY_PATH = "res://sprites/characters/body/"
const SHIRT_PATH = "res://sprites/characters/shirt/"
const PANTS_PATH = "res://sprites/characters/pants/"
const SHOES_PATH = "res://sprites/characters/shoes/"
const PROJECTILE_PATH = "res://sprites/characters/projectile/"

func getHairs():
	return Database.getPathsOfDir(HAIR_PATH)
func getPathOfHair()->String:
	return HAIR_PATH + str(meta.hair) + ".png"

func getEyes():
	return Database.getPathsOfDir(EYES_PATH)
func getPathOfEyes():
	return EYES_PATH + str(meta.eyes) + ".png"

func getBody():
	return Database.getPathsOfDir(BODY_PATH)
func getPathOfBody():
	return BODY_PATH + str(meta.body) + ".png"

func getShirt():
	return Database.getPathsOfDir(SHIRT_PATH)
func getPathOfShirt():
	return SHIRT_PATH + str(meta.shirt) + ".png"

func getPants():
	return Database.getPathsOfDir(PANTS_PATH)
func getPathOfPants():
	return PANTS_PATH + str(meta.pants) + ".png"

func getShoes():
	return Database.getPathsOfDir(SHOES_PATH)
func getPathOfShoes():
	return SHOES_PATH + str(meta.shoes) + ".png"

func getProjectile():
	return Database.getPathsOfDir(PROJECTILE_PATH)
func getPathOfProjectile():
	return PROJECTILE_PATH + str(meta.projectile) + ".png"
