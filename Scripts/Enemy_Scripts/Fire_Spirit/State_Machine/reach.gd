extends EnemyState
var keepfollow = true

func state_enter_state(msg := {}):
	keepfollow = true
	print('reach state entered ')
	$"../../countdown".start()
	fireSpirit.animation.play('count')
	fireSpirit.speed = 80
	if fireSpirit.playerSawn.sprite.flip_h == false:
		fireSpirit.global_position = Vector2(fireSpirit.playerSawn.global_position.x + 25, fireSpirit.playerSawn.global_position.y - 25)
	else:
		fireSpirit.global_position = Vector2(fireSpirit.playerSawn.global_position.x - 25, fireSpirit.playerSawn.global_position.y - 25 )
	

func state_physics_process(delta):
	if keepfollow:
		fireSpirit.moveTo(fireSpirit.playerSawn.global_position, delta)
#		if fireSpirit.playerSawn.sprite.flip_h == false:
#			fireSpirit.global_position = Vector2(fireSpirit.playerSawn.global_position.x + 25, fireSpirit.playerSawn.global_position.y - 25) 
#		else:
#			fireSpirit.global_position = Vector2(fireSpirit.playerSawn.global_position.x - 25, fireSpirit.playerSawn.global_position.y - 25 ) 
	else:
		state_machine.transition_to("explode")


func _on_countdown_timeout():
	print("-----------------------------------------countdown timer")
	keepfollow = false
	
	
func state_exit():
	$"../../countdown".stop()
	fireSpirit.speed = 100

