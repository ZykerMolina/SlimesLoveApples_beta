extends PlayerState

var releasedJumpKey : bool = false
func state_enter_state(msg := {}):
	player.jump()
	
	
func state_process(delta):
	player.adjustPosition(delta)
	if Input.is_action_just_released("ui_accept"):
		releasedJumpKey = true
	if player.is_on_floor():
		state_machine.transition_to("idle")
	elif releasedJumpKey and Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("doubleJump")
	elif player.is_dead():
		state_machine.transition_to("dead")
		
func state_exit():
	releasedJumpKey = false
