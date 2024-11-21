extends EnemyState

func state_enter_state(msg := {}):
	print("- EXPLODE - STATE ENTERED FIRESPIRIT")
	fireSpirit.explode()

func state_physics_process(delta):
	if fireSpirit.needRespawn :
		state_machine.transition_to("rebirth")
