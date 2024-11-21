extends RigidBody2D
class_name Apple_Rigid
@onready var anim = $AnimationPlayer

func _on_body_entered(body):
	if body is Player:
		print("Manzana Tomada!")
		self.freeze = true
		#queue_free()
	if body is Floor: 
		anim.play("destroy")
		await (anim.animation_finished)
		queue_free()
