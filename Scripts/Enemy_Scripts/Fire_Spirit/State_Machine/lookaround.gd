extends EnemyState

const maxreps = 4
var reps : int = 0

func state_enter_state(msg := {}):
	$"../../lookaroundwait".stop()
	fireSpirit.enableAllCollitions(false)
	print("lookaround state")
	fireSpirit.enablePerception(false)
	fireSpirit.enablePerception(true)
	fireSpirit.animation.play("idle")
	if msg.has("reps"):
		reps = msg["reps"] + 1
	else :
		reps = 1
	if reps <= maxreps :
		fireSpirit.lookBakwards()
		$"../../lookaroundwait".start()
	

func state_physics_process(delta):
	if fireSpirit.perceivedSomething :
		state_machine.transition_to("stalk",{"position" : fireSpirit.perceivedLocation})
		

func _on_lookaroundwait_timeout():
	print("timeout lookarount")
	if reps < maxreps:
		state_machine.transition_to("lookaround",{"reps": reps })
	else:
		state_machine.transition_to("stalk")


func state_exit():
	$"../../lookaroundwait".stop()
