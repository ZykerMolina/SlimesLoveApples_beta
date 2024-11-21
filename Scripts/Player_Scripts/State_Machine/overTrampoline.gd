extends PlayerState

func state_enter_state(msg := {}):
	player.set_idle()
	
func state_process(delta):
	var direccionx = Input.get_axis("izquierda","derecha")
	player.adjustPosition(delta)
	if direccionx != 0:
		state_machine.transition_to("movement")
	elif !player.is_on_floor():
		state_machine.transition_to("falling")
	elif Input.is_action_just_pressed("ui_accept") :
		print("Jumped deiding which jump it is " , player.get_jumped_over_trampoline() )
		if player.get_jumped_over_trampoline():
			state_machine.transition_to("trampolineJump")
		else:
			state_machine.transition_to("jump")
	elif Input.is_action_just_pressed("abajo"):
		state_machine.transition_to("trampolineMode")

func state_exit():
	#player.set_jumped_over_trampoline(false)
	pass
