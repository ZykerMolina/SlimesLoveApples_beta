extends PlayerState

func state_enter_state(msg := {}):
	player.setTrampolineColisionArea(true)
	
func state_process(delta):
	var direccion = Input.get_axis("izquierda","derecha")
	if direccion != 0:
		state_machine.transition_to("movement")
#	elif Input.is_action_just_released("abajo"):
#		state_machine.transition_to("idle")
	elif player.is_dead():
		state_machine.transition_to("dead")
