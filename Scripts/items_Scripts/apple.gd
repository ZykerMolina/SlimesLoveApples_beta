extends Area2D
class_name Apple

func _on_body_entered(body):
	print("Manzana estatica tomada!")
	if body is Player: 
		queue_free()
