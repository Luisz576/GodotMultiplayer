extends Control

var server_ip_target = ""
var starting = false

func _ready():
	Database._setupDefaultVarsIfIsTheFirstTime()
	# warning-ignore:return_value_discarded
	Networking.connect("server_created", self, "on_server_created")
	# warning-ignore:return_value_discarded
	Networking.connect("server_closed", self, "on_server_close")
	# warning-ignore:return_value_discarded
	Networking.connect("creating_server_error", self, "on_server_creating_error")
	# warning-ignore:return_value_discarded
	Networking.connect("server_connect_error", self, "on_failed_connect_to_server")
	# warning-ignore:return_value_discarded
	Networking.connect("server_connected", self, "on_server_connect")
	# warning-ignore:return_value_discarded
	Networking.connect("connection_error", self, "on_error_of_connection")
	# warning-ignore:return_value_discarded
	Networking.connect("new_client_connected", self, "on_new_client_connected")
	pass

#server signals
func on_server_created():
	$msg_text.text = "Chame alguem para jogar com você: " + str(Networking.getIpAddress())
	$bt_comecar_cancelar_partida.disabled = false
	$bt_comecar_cancelar_partida.text = "Cancelar"
	pass

func on_server_connect():
	$msg_text.text = "Conectado!"
	$bt_entrar_partida.text = "Conectado!"
	pass

func on_server_close():
	$msg_text.text = ""
	$bt_comecar_cancelar_partida.text = "Jogar"
	$bt_comecar_cancelar_partida.disabled = false
	$bt_entrar_partida.disabled = false
	$bt_editar_cartas.disabled = false
	pass

func on_failed_connect_to_server():
	$msg_text.text = "Host não encontrado!"
	$bt_entrar_partida.text = "Entrar na partida"
	$bt_comecar_cancelar_partida.disabled = false
	$bt_entrar_partida.disabled = false
	$bt_editar_cartas.disabled = false
	pass

func on_server_creating_error():
	$msg_text.text = "Erro ao criar servidor..."
	$bt_comecar_cancelar_partida.text = "Jogar"
	$bt_comecar_cancelar_partida.disabled = false
	$bt_entrar_partida.disabled = false
	$bt_editar_cartas.disabled = false
	pass

func on_error_of_connection():
	$msg_text.text = "Erro de conexão..."
	$bt_comecar_cancelar_partida.disabled = false
	$bt_entrar_partida.text = "Entrar na partida"
	$bt_entrar_partida.disabled = false
	$bt_editar_cartas.disabled = false
	pass

#TODO: START GAME
func on_new_client_connected(_id):
	rpc("startGame")
	pass

#signals
func _on_bt_comecar_cancelar_partida_button_down():
	if !starting:
		$bt_comecar_cancelar_partida.text = "Criando servidor..."
		$bt_comecar_cancelar_partida.disabled = true
		$bt_entrar_partida.disabled = true
		$bt_editar_cartas.disabled = true
		Networking.createServer()
	else:
		$bt_comecar_cancelar_partida.text = "Cancelando..."
		$bt_comecar_cancelar_partida.disabled = true
		Networking.stopServer()
	starting = !starting
	pass

func _on_bt_entrar_partida_button_down():
	if(server_ip_target != ""):
		$bt_entrar_partida.text = "Conectando..."
		$bt_comecar_cancelar_partida.disabled = true
		$bt_entrar_partida.disabled = true
		$bt_editar_cartas.disabled = true
		Networking.joinServer(server_ip_target)
	else:
		$msg_text.text = "Informe o endereço do host"
	pass

func _on_bt_editar_cartas_button_down():
	return get_tree().change_scene("res://scenes/EditDeck.tscn")

func _on_id_edit_text_changed():
	server_ip_target = $id_edit.text
	pass

#REMOTESYNC FUNCS
remotesync func startGame():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Battle.tscn")
	pass
