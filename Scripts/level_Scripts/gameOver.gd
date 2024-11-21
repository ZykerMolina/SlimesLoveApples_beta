extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.peer.close()


func _on_aceptar_pressed():
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")
