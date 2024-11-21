extends EnemyState

const maxreps = 3

func state_enter_state(msg := {}):
	#fireSpirit.animation.play("idle")
	
	print("- idle - STATE ENTERED FIRESPIRIT")

func state_physics_process(delta):
	
	if fireSpirit.playerCollision == true:
		state_machine.transition_to("attack")
