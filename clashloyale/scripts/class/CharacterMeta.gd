extends Resource
class_name CharacterMeta

enum Skills { NONE, CURE, DEATH_EXPLODE, ELIXIR }

export(String) var nome = "Teste"

#APPEARANCE
export(int) var hair = 0
export(int) var eyes = 0
export(int) var body = 0
export(int) var shirt = 0
export(int) var pants = 0
export(int) var shoes = 0

export(int) var projectile = 0

#STATISTICS
export(int) var healthLevel = 1
export(int) var strengthLevel = 1
export(int) var velocityLevel = 1
export(int) var shootVelocityLevel = 1

export(int) var reachLevel = 0

#SKILL
export(Skills) var skill = Skills.NONE
export(int) var skillLevel = 1

#SAVE FUNCS
func toObject():
	return {
		"nome": nome,
		"hair": hair,
		"eyes": eyes,
		"body": body,
		"shirt": shirt,
		"pants": pants,
		"shoes": shoes,
		"projectile": projectile,
		"healthLevel": healthLevel,
		"strengthLevel": strengthLevel,
		"velocityLevel": velocityLevel,
		"reachLevel": reachLevel,
		"shootVelocityLevel": shootVelocityLevel,
		"skill": skill,
		"skillLevel": skillLevel
	}

func loadFromObject(data):
	if data != null:
		nome = data["nome"]
		hair = data["hair"]
		eyes = data["eyes"]
		body = data["body"]
		shirt = data["shirt"]
		pants = data["pants"]
		shoes = data["shoes"]
		projectile = data["projectile"]
		healthLevel = data["healthLevel"]
		strengthLevel = data["strengthLevel"]
		velocityLevel = data["velocityLevel"]
		reachLevel = data["reachLevel"]
		shootVelocityLevel = data["shootVelocityLevel"]
		skill = data["skill"]
		skillLevel = data["skillLevel"]
	pass
