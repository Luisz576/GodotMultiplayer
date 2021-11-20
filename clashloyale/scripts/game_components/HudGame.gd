extends Control

var gameController = null
var players_elixir_nodes = []

func setup(GC, playersNumber):
	gameController = GC
	for i in range(playersNumber):
		players_elixir_nodes.append(get_node("elixir_player_" + str((i + 1))))
	pass

func _updateHud():
	if gameController != null:
		$timer.text = _tratarTempo(gameController.timer)
		for i in range(players_elixir_nodes.size()):
			if gameController.playersElixir.size() > i:
				players_elixir_nodes[i].text = str(gameController.playersElixir[i])
	pass

func _tratarTempo(time)->String:
	var minutes = time / 60
	var seconds = time % 60
	var secondsS = str(seconds) if seconds >= 10 else ("0" + str(seconds))
	return str(minutes) + ":" + secondsS
