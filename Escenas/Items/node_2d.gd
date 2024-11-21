extends Node2D
class_name Trampoline

func _on_area_2d_body_entered(body):
	if body is Player:
		print("ENTRADA !!!")
		body.set_jumped_over_trampoline(true)

func _on_area_2d_body_exited(body):
	if body is Player:
		print("SALIDA !!!")
		body.set_jumped_over_trampoline(false)
