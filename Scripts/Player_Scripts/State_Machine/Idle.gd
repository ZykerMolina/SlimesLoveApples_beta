extends PlayerState

func state_enter_state(msg := {}):
	#print("IDLE STATE ENTERED", GlobalVar.players[player.name])
	player.set_idle()
	
func state_process(delta):
	var direccionx = Input.get_axis("izquierda","derecha")
	player.adjustPosition(delta)
	if direccionx != 0:
		state_machine.transition_to("movement")
	elif !player.is_on_floor():
		state_machine.transition_to("falling")
	elif Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("jump")
	elif Input.is_action_just_pressed("abajo"):
		state_machine.transition_to("trampolineMode")
	elif player.is_dead():
		state_machine.transition_to("dead")
	elif GlobalVar.is_online: 
		if GlobalVar.players[player.name].stepedTrampoline:
			state_machine.transition_to("trampolineJump")
	elif !GlobalVar.is_online: 
		if player.set_jumped_trampoline == true:
			state_machine.transition_to("trampolineJump") 
