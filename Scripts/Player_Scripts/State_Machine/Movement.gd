extends PlayerState

@export var acceleration = 600.0
@export var friction = 1200.0

func state_enter_state(msg := {}):
	player.walk()
	player.setTrampolineColisionArea(false)

func state_physics_process(delta):
	var directionx = Input.get_axis("izquierda","derecha")
	player.adjustPosition(delta)
	
	if directionx == 0:
		state_machine.transition_to("idle")
	elif !player.is_on_floor():
		state_machine.transition_to("falling")
	elif Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("jump")
	elif player.is_dead():
		state_machine.transition_to("dead")
#	elif Input.is_action_just_pressed("abajo"):
#		state_machine.transition_to("trampolineMode")

#*************************************************************************************


#@export var acceleration = 600.0
#@export var friction = 1200.0
##@export var air_acceleration = 1200.0
##@export var air_friction = 1200.0
#
#func update(delta):
#	print("UPDATE")
#	apply_gravity(delta)
#	#move(player.input_axis)
##
#func apply_gravity(delta):
#	if not player.is_on_floor():
#		player.velocity.y += player.gravity * delta
#
#func move(direction):
#	print("Entro")
#	if player.input_axis.x != 0:
#		print("IF")
#		player.velocity.x = move_toward(player.velocity.x, direction * player.player_speed, acceleration * tick)
#	elif player.input_axis.x == 0:
#		player.velocity.x = move_toward(player.velocity.x, 0.0, friction * tick)
#	player.move_and_slide()
