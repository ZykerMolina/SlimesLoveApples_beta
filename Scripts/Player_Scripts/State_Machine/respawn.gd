extends PlayerState

func state_enter_state(msg := {}):
	player.respawn()
	
func state_physics_process(delta):
	if !player.is_dead():
		state_machine.transition_to("idle")
