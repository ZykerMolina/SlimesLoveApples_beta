extends Node

func _ready():
	print("MAIN MENU ..................... restarttgin variables")
	GlobalVar.is_online = false
	GlobalVar.gameOver = false
	GlobalVar.is_online = false
	GlobalVar.next_Level = false
	GlobalVar.players = {}
	GlobalVar.life_apples = 3

func _on_solo_play_pressed():
	get_tree().change_scene_to_file("res://Escenas/select_player.tscn")
	#$VBoxContainer/soloPlay/select.play()

func _on_exit_pressed():
	get_tree().quit()


func _on_background_ready():
	$VBoxContainer/soloPlay/backgroundWeird.play()


func _on_background_weird_finished():
	$VBoxContainer/soloPlay/backgroundWeird.play()


func _on_host_pressed():
	print("host pressed")
	GlobalVar.is_host = true
	get_tree().change_scene_to_file("res://Escenas/select_player.tscn")


func _on_join_pressed():
	print("Join pressed")
	GlobalVar.is_host = false
	get_tree().change_scene_to_file("res://Escenas/select_player.tscn")


func _on_back_pressed():
	GlobalVar.is_online = false
	$VBoxContainer.show()
	$Multiplayer.hide()


func _on_multiplayer_pressed():
	GlobalVar.is_online = true
	$VBoxContainer.hide()
	$Multiplayer.show()
	
