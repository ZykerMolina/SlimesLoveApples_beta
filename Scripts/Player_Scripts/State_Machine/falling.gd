extends PlayerState


func state_enter_state(msg := {}):
	pass

func state_physics_process(delta):
	var directionx = Input.get_axis("izquierda","derecha")
	player.adjustPosition(delta)
	if player.is_dead():
		state_machine.transition_to("dead")
	elif player.is_on_floor():
		state_machine.transition_to("idle")
	elif Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("doubleJump")
	elif GlobalVar.is_online:
		if GlobalVar.players[player.name].stepedTrampoline:
			state_machine.transition_to("trampolineJump")

func state_exit():
	player.communicateTrampolineJump(player.name, false)
