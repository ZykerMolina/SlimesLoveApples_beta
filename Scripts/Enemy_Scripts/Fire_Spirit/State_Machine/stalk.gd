extends EnemyState

const mindistance = 10
const maxdistance = 15
var isjuststalk = false
var target : Vector2

func state_enter_state(msg := {}):
	print("POSITION: ",fireSpirit.global_position)
	var distanceX : int
	var distanceY : int
	print("stalk state")
	if msg.has('position'):
		print("IF --------------------------------------")
		fireSpirit.animation.play("attack")
		fireSpirit.speed = 160
		isjuststalk = false
		var nex = 0
		var ney = 0
		if fireSpirit.global_position.x > msg['position'].x:
			nex = msg['position'].x + 25
		else :
			nex = msg['position'].x - 25
		if fireSpirit.global_position.y > msg['position'].y:
			ney = msg['position'].y + 25
		else :
			ney = msg['position'].y - 25
		target = Vector2(nex, ney)
	else:
		print("ELSE --------------------------------------")
		isjuststalk = true
		distanceX = (randi() % maxdistance) + mindistance
		distanceY = (randi() % maxdistance) + mindistance
		print("X",distanceX)
		print("X",distanceY)
		if fireSpirit.global_position.x > 0 and distanceX % 2 == 0 :
			print("1")
			distanceX = distanceX * -1
		if fireSpirit.global_position.y > -200 and distanceY % 2 == 0 :
			print("2")
			distanceY = distanceY * -1
		if fireSpirit.global_position.x > 1000  :
			print("3")
			distanceX = distanceX * -1
		if fireSpirit.global_position.y > 10 :
			print("4")
			distanceY = distanceY * -1
		target = Vector2(fireSpirit.global_position.x + distanceX, fireSpirit.global_position.y + distanceY )
		print("TARGET ",target)
	

func state_physics_process(delta):
	if fireSpirit.global_position == target and isjuststalk:
		state_machine.transition_to("lookaround")
	elif fireSpirit.global_position == target and !isjuststalk:
		state_machine.transition_to("countdown")
	else :
		fireSpirit.moveTo(target, delta)

