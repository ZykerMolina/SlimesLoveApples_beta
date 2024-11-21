extends Node2D
#class_name Jump 

var player : Player
var air_jump : bool
var coyote_jump : bool = false
var first_jump : bool
var coyoteTimer_Started : bool = false
@onready var timer = $"../Timer"

func setup(body):
	player = body
	
func update(_delta):

	if not player.is_on_floor() and coyote_jump == true and first_jump == false and coyoteTimer_Started == false:
		#print("start")
		coyoteTimer_Started = true
		$"../Coyote_Timer".start()
		
	if player.is_on_floor():
		air_jump = true
		coyote_jump = true
		first_jump = false
		player.set_respawn_position(player.position)
		if Input.is_action_just_pressed("ui_accept"):
			#print("1")
			first_jump = true
			$"../Sonidos/jump".play()
			player.velocity.y = player.player_jump_speed
			animaciones()
	
	elif not player.is_on_floor():
		if Input.is_action_just_pressed("ui_accept") and coyote_jump == true and first_jump == false:
			#print("2:", coyote_jump)
			player.velocity.y = player.player_jump_speed
			coyote_jump = false
			animaciones()
		#print("player.velocity.y: ",player.velocity.y)
		elif Input.is_action_just_pressed("ui_accept") and air_jump == true:
			#print("3")
			$"../Sonidos/airJump".play()
			player.velocity.y = player.player_jump_speed * 0.85
			air_jump = false
			
	#JumpDown provicional
	#if player.velocity.y > 0:
		#print("jump_down")
		#player.animation_Player.play("jump_down")

func animaciones():
	#JumpDown aqui no se manda a llamar
#	if player.velocity.y > 0:
#		print("jump_down")
#		player.animation_Player.play("jump_down")
	if player.velocity.y < 0:
		#print("jump_up")
		player.animation_Player.play("jump_up")

#func _on_coyote_timer_timeout():
#	coyote_jump = false
#	coyoteTimer_Started = false
#	#print("Booooom !")
