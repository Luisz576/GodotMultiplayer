extends Node

#CONSTS
const MAX_JOGADORES = 2
const DEFAULT_PORT = 3030

#SERVER
var peer = null
var ip_server = ""

var jogadores = []
var numeroJogadores = 0

signal server_created
signal server_closed
signal server_connected
signal new_client_connected(jogadorId)
signal disconnected_client
signal server_kicked(reason)
signal server_connect_error
signal creating_server_error
signal connection_error

#FUNCS
func getPeer():
	return peer

func getIpServer():
	return ip_server

func getJogadores():
	return jogadores

func getNumeroJogadores():
	return numeroJogadores

func getJogadorIndexById(id):
	var jogadorIndex = -1
	for i in jogadores:
		if i == id:
			jogadorIndex = i
	return jogadorIndex

func getConnectionId():
	return get_tree().get_network_unique_id()

func getIpAddress():
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			return address
	return null

#READY
func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "conectado_no_servidor")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "erro_de_conexao")
	pass

#SERVER FUNCS
func createServer():
	peer = NetworkedMultiplayerENet.new()
	var res = peer.create_server(DEFAULT_PORT, MAX_JOGADORES)
	if res != OK:
		print("Error creating server...")
		peer = null
		emit_signal("creating_server_error")
		return
	get_tree().set_network_peer(peer)
	peer.connect("peer_disconnected", self, "client_disconectado_do_servidor")
	peer.connect("peer_connected", self, "registrarJogador")
	ip_server = getIpAddress()
	registrarJogador(getConnectionId())
	print("Servidor criado")
	emit_signal("server_created")
	pass

func client_disconectado_do_servidor(idJogador):
	var pos = 0
	for i in range(numeroJogadores):
		if jogadores[i] == idJogador:
			pos = i
	print("Peer desconectado: " + str(idJogador))
	rpc("removerJogador", pos)
	pass

func stopServer():
	#kick players
	for i in jogadores:
		if i != 1:
			rpc_id(i, "kicked", "Server Closed")
			get_tree().network_peer.disconnect_peer(i)
	#Terminate server
	get_tree().set_network_peer(null)
	#RESET SERVER VARS
	peer = null
	ip_server = ""
	jogadores = []
	numeroJogadores = 0
	print("Servidor fechado")
	emit_signal("server_closed")
	pass

func joinServer(ipServerTarget):
	peer = NetworkedMultiplayerENet.new()
	var res = peer.create_client(ipServerTarget, DEFAULT_PORT)
	if res != OK:
		print("Error connecting to server...")
		peer = null
		emit_signal("server_connect_error")
		return
	get_tree().set_network_peer(peer)
	ip_server = ipServerTarget
	emit_signal("server_connected")
	pass

#CLIENT SIGNALS
func conectado_no_servidor():
	print("Conectado no servidor")
	registrarJogador(get_tree().get_network_unique_id())
	pass

func erro_de_conexao():
	print("Erro de conexão")
	emit_signal("connection_error")
	pass

#REMOTE FUNCS
remote func registrarJogador(jogadorId):
	if get_tree().is_network_server():
		for i in range(numeroJogadores):
			#manda info sobre players já conectados
			rpc_id(jogadorId, "registrarJogador", jogadores[i])
		rpc("registrarJogador", jogadorId)
		if jogadorId != 1:
			emit_signal("new_client_connected", jogadorId)
			print("Jogador conectado: " + str(jogadorId))
	jogadores.append(jogadorId)
	numeroJogadores += 1
	pass

remote func kicked(reason):
	print("Kicked: " + str(reason))
	get_tree().network_peer.disconnect_peer(getConnectionId())
	emit_signal("server_kicked", reason)
	pass

#REMOTESYNC FUNCS
remotesync func removerJogador(index):
	jogadores.remove(index)
	numeroJogadores -= 1
	emit_signal("disconnected_client")
	pass
