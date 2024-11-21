extends EnemyState

func state_enter_state(msg := {}):
	print(' rebirth state entered ')
	fireSpirit.rebirth()
	state_machine.transition_to("lookaround")
	

func state_physics_process(delta):
	pass

