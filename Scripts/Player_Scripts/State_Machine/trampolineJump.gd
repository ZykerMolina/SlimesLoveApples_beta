extends PlayerState

func state_enter_state(msg := {}):
	#print("TRAMPOLINE STATE ENTERED", GlobalVar.players[player.name])
	player.trampolineJump()
	
func state_process(delta):
	player.adjustPosition(delta)
	if player.is_dead():
		state_machine.transition_to("dead")
	elif Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("doubleJump")
	elif player.is_on_floor():
		state_machine.transition_to("idle")

func state_exit():
	player.communicateTrampolineJump(player.name, false)
