extends Area2D
@onready var anim = $Sprite2D/AnimationPlayer

func _on_body_entered(body):
	if body is Player:
		#anim.play("touch")
		print("Nuevo Checkpoint")
		var position = self.position
		body.set_respawn_position(position)
