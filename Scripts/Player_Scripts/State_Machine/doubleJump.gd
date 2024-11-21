extends PlayerState

func state_enter_state(msg := {}):
	player.jump()
	
func state_physics_process(delta):
	player.adjustPosition(delta)
	if player.is_on_floor():
		state_machine.transition_to("idle")
	elif player.is_dead():
		state_machine.transition_to("dead")
