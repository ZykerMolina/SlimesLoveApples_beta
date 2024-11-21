extends PlayerState
var jumpReleased : bool = false

func state_enter_state(msg := {}):
	jumpReleased = false
	if msg.has("Jump"):
		print("Jump")
		$"../../Sonidos/jump".play()
		player.velocity.y = player.player_jump_speed
		player.animation_Player.play("jump_up")
		player.set_respawn_position(player.position)
	elif msg.has("Jump_Trampoline"):
		print("Jump_Trampoline")
		player.velocity.y = player.player_jump_speed - 500
		player.animation_Player.play("jump_up")
		player.set_trampoline(false)
	else:
		$"../../Sonidos/landing".play()
	
func state_physics_process(delta):
	var direction = Input.get_axis("izquierda","derecha")
	player.velocity.x = direction * player.player_speed
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("ui_accept") and jumpReleased == true:
		state_machine.transition_to("doubleJump")
	elif Input.is_action_just_released("ui_accept"):
		jumpReleased = true
	elif player.get_trampoline() == true:
		state_machine.transition_to("inAir",{Jump_Trampoline = true})
