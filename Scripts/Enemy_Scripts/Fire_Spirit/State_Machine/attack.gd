extends EnemyState

func state_enter_state(msg := {}):
	print("- ATTACK - STATE ENTERED FIRESPIRIT")

	fireSpirit.move = fireSpirit.global_position.direction_to(fireSpirit.playerPositionDetected)
	print("Colision en la direccion: ",fireSpirit.playerPositionDetected)
	fireSpirit.animation.play("attack")
	fireSpirit.move = fireSpirit.move.normalized() * fireSpirit.speed
	fireSpirit.move = fireSpirit.move_and_collide(fireSpirit.move)
	fireSpirit.move_and_slide()

func state_physics_process(delta):
	
	if fireSpirit.playerCollision == true:
		state_machine.transition_to("attack")
	elif fireSpirit.playerCollision == false:
		state_machine.transition_to("idle")
