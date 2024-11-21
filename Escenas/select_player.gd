extends Node2D
class_name Select_Player 

@onready var animation_green = $Buttons/slime_green/Sprite2D/AnimationPlayer
@onready var animation_blue = $Buttons/slime_blue/Sprite2D/AnimationPlayer
@onready var animation_red = $Buttons/slime_red/Sprite2D/AnimationPlayer
@onready var animation_yellow = $Buttons/slime_yellow/Sprite2D/AnimationPlayer
@onready var nombre = $Labels/name_Text
var conectados : int = 1
var jugadoresConfirmed = 0

func _enter_tree():
	if GlobalVar.is_online:
		if GlobalVar.is_host:
			$Buttons/Aceptar.text = "Esperando jugadores"
			GlobalVar.peer.create_server(GlobalVar.port, GlobalVar.max_players - 1)
			GlobalVar.peer.peer_connected.connect(addNewPlayer)
		else:
			GlobalVar.peer.create_client("localhost", GlobalVar.port)
			multiplayer.connected_to_server.connect(requestSync)
		multiplayer.multiplayer_peer = GlobalVar.peer
	else:
		pass
	

func _ready():
	if GlobalVar.is_online :
		$Labels/conectados.text = str(conectados) + "/4 jugadores"
	else :
		$Labels/conectados.text = "Playing Solo"
	$Buttons/Aceptar.disabled = true
	
func _on_slime_green_pressed():
	animation_green.play("idle_green")
	GlobalVar.player_Selected = "Green"
	stopAnimation()
	#player.player_Selected = "Green"

func _on_slime_blue_pressed():
	animation_blue.play("idle_blue")
	GlobalVar.player_Selected = "Blue"
	stopAnimation()
	#player.player_Selected = "Blue"

func _on_slime_red_pressed():
	animation_red.play("idle_red")
	GlobalVar.player_Selected = "Red"
	stopAnimation()
	#player.player_Selected = "Red"

func _on_slime_yellow_pressed():
	animation_yellow.play("idle_yellow")
	GlobalVar.player_Selected = "Yellow"
	stopAnimation()
	#player.player_Selected = "Yellow"

func _on_aceptar_pressed():
	GlobalVar.player_Name = nombre.text
	print("nombre: ", GlobalVar.player_Name)
	if GlobalVar.is_online :
		confirm_ready.rpc()
		$Buttons/Aceptar.text = "Iniciando"
		$Buttons/Aceptar.disabled = true
	else :
		get_tree().change_scene_to_file("res://Escenas/Game.tscn")
	
func stopAnimation():
	#$select.play()
	animation_green.stop()
	animation_blue.stop()
	animation_red.stop()
	animation_yellow.stop()
	if !GlobalVar.is_online:
		GlobalVar.players[1] = {"color":GlobalVar.player_Selected,"id":"1"}
	if !GlobalVar.is_online or !GlobalVar.is_host:
		$Buttons/Aceptar.disabled = false
	if GlobalVar.is_host :
		#jugadoresConfirmed += 1
		if conectados > 1:
			$Buttons/Aceptar.disabled = false
	if GlobalVar.is_online :
		slimeSelected.rpc(str(multiplayer.get_unique_id()), GlobalVar.player_Selected)
		
func _on_background_ready():
	pass
	#$background.play()
	
func addNewPlayer(id : int = get_multiplayer_authority()) :
	print("================================================ new player incoming")
	conectados += 1
	$Labels/conectados.text = str(conectados) + "/4 jugadores"
	$Buttons/Aceptar.text = "aceptar"
	aknowledgeConnection.rpc(conectados)

@rpc("authority", "call_remote", "reliable")
func aknowledgeConnection(peers : int):
	conectados = peers
	$Labels/conectados.text = str(conectados) + "/4 jugadores"
	
@rpc("any_peer", "call_local", "reliable")
func confirm_ready():
	jugadoresConfirmed += 1
	if GlobalVar.is_online:
		if GlobalVar.is_host :
			print("selected " + str(GlobalVar.player_Selected))
			if jugadoresConfirmed >= 1 and GlobalVar.player_Selected != "":
				$Buttons/Aceptar.text = "Aceptar"
				$Buttons/Aceptar.disabled = false
			if jugadoresConfirmed == conectados and jugadoresConfirmed > 1 : 
				get_tree().change_scene_to_file("res://Escenas/Game.tscn")
				start.rpc()
			
	

@rpc("any_peer", "call_local", "reliable")
func slimeSelected(id: String, slime : String):
	GlobalVar.players[id] = {"color": slime, "id" : id, "stepedTrampoline": false}
	update_synced_slimes()
	
func requestSync():
	print("Requesting sync")
	syncData.rpc({"id": multiplayer.get_unique_id()})
	
@rpc("any_peer", "call_remote", "reliable")	
func syncData(data:Dictionary):
	print("Sending Sync datato newjoiners")
	if !GlobalVar.is_host:
		conectados = data.conectados
		$Labels/conectados.text = str(conectados) + "/4 jugadores"
		GlobalVar.players = data.players
		update_synced_slimes()
	else:
		syncData.rpc({"id" : multiplayer.get_unique_id(), 
			"conectados": conectados, "players" : GlobalVar.players})

func update_synced_slimes():
	$Buttons/slime_green.disabled = false
	$Buttons/slime_blue.disabled = false
	$Buttons/slime_red.disabled = false
	$Buttons/slime_yellow.disabled = false
	for sel in GlobalVar.players:
		var tmpSel = GlobalVar.players[sel]
		if tmpSel.color == "Yellow":
			$Buttons/slime_yellow.disabled = true
		if tmpSel.color == "Blue":
			$Buttons/slime_blue.disabled = true
		if tmpSel.color == "Red":
			$Buttons/slime_red.disabled = true
		if tmpSel.color == "Green":
			$Buttons/slime_green.disabled = true
			
@rpc("authority", "call_remote", "reliable")	
func start():
	get_tree().change_scene_to_file("res://Escenas/Game.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")
