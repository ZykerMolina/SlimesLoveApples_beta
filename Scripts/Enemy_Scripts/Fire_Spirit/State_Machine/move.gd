extends EnemyState

func state_enter_state(msg := {}):
	print("- MOVE - STATE ENTERED FIRESPIRIT")

func state_physics_process(delta):
	
	if fireSpirit.playerCollision == true:
		state_machine.transition_to("attack")
