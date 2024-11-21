extends PlayerState
var respawnTimeout: bool = false

func state_enter_state(msg := {}):
	player.kill_slime()
	
func state_physics_process(delta):
	player.adjustPosition(delta)
	
	if player.is_dead():
		state_machine.transition_to("respawn")

#	if player.is_dead() and respawnTimeout == true:
#		state_machine.transition_to("respawn")

#func _on_timer_timeout():
#	respawnTimeout = true
