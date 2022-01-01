extends Control

const TIME_MESSAGE_SHOWING = 2

var gameController = null
var players_elixir_nodes = []

var message_showing_time = 0

func setup(GC, playersNumber):
	gameController = GC
	for i in range(playersNumber):
		players_elixir_nodes.append(get_node("elixir_player_" + str((i + 1))))
	pass

#updates
func _updateHud():
	if gameController != null:
		$timer.text = _tratarTempo(gameController.timer)
		for i in range(players_elixir_nodes.size()):
			if gameController.playersElixir.size() > i:
				players_elixir_nodes[i].text = str(gameController.playersElixir[i])
	pass

#funcs
func _tratarTempo(time)->String:
	var minutes = time / 60
	var seconds = time % 60
	var secondsS = str(seconds) if seconds >= 10 else ("0" + str(seconds))
	return str(minutes) + ":" + secondsS

func showMessage(message):
	message_showing_time = TIME_MESSAGE_SHOWING
	$error_message.text = message
	$error_message.visible = true
	pass

func _on_GameTimer_timeout():
	if(message_showing_time > 0):
		message_showing_time -= 1
	else:
		$error_message.visible = false
