extends Node2D

var manzanaObj = preload("res://Escenas/Items/apple_Rigid.tscn")


func _on_timer_timeout():
	print("Manzana creada !")
	var manzana = manzanaObj.instantiate()
	add_child(manzana)
