extends CharacterBody2D
class_name FireSpirit
var fireSpirit : FireSpirit
var player : Player

var speed = 80
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move = Vector2.ZERO
var playerCollision: bool = false
var playerSawn : Player = null
var perceivedLocation : Vector2
var perceivedSomething : bool = false
var needRespawn : bool = false
var respawnposition : Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D 
@onready var animation = $AnimationPlayer
@onready var rayCast_1 = $RayCast_1
@onready var rayCast_2 = $RayCast_2
@onready var rayCast_3 = $RayCast_3
@onready var rayCast_4 = $RayCast_4
@onready var rayCast_5 = $RayCast_5

func _ready():
	#$perception.disabled = true
	pass

func _physics_process(_delta):
	
	pass 
	
func _process(_delta):
	$Label.text = $StateMachine.state.name
	flip_Sprite()
	rayCastDetected()
	
func flip_Sprite():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
func lookBakwards():
	direction = direction * -1
	sprite.flip_h = !sprite.flip_h 

func rayCastDetected():
#	print("I saw something")
#	enableVision(false)
#	var collision
#	playerCollision = false
#	if rayCast_1.is_colliding():
#		collision = rayCast_1.get_collider()
#		rayCastIdentifier(collision)
#	elif rayCast_2.is_colliding():
#		collision = rayCast_2.get_collider()
#		rayCastIdentifier(collision)
#	elif rayCast_3.is_colliding():
#		collision = rayCast_3.get_collider()
#		rayCastIdentifier(collision)
#	elif rayCast_4.is_colliding():
#		collision = rayCast_4.get_collider()
#		rayCastIdentifier(collision)
#	elif rayCast_5.is_colliding():
#		collision = rayCast_5.get_collider()
#		rayCastIdentifier(collision)
	pass
		
func rayCastIdentifier(collision):
	#playerPositionDetected = Vector2.ZERO
	if collision.is_in_group("Player"):
		playerCollision = true
		playerSawn = collision
		

func moveTo(position: Vector2, delta: float):
		self.global_position = self.global_position.move_toward(position , delta * speed)
	
#func rayCastIdentifier(collision):
#	var playerPositionDetected
#	move = Vector2.ZERO
#	if collision.is_in_group("Player"):
#		playerPositionDetected = collision.global_position
#		move = global_position.direction_to(playerPositionDetected)
#		print("Colision: ",collision," en la direccion: ",playerPositionDetected)
#		animation.play("attack")
#		move = move.normalized() * speed
#		move = move_and_collide(move)
#		move_and_slide()
#	else:
#		move = Vector2.ZERO
#		animation.play("idle")

func enablePerception(enabled : bool):
	
	if enabled :
		$perception/CollisionShape2D.disabled = false
		perceivedSomething = false
	else:
		$perception/CollisionShape2D.disabled = true
		
func enableVision(enabled : bool):
	if enabled :
		playerSawn = null
	$RayCast_1.enabled = false
	$RayCast_1.force_raycast_update()
	$RayCast_2.enabled = false
	$RayCast_2.force_raycast_update()
	$RayCast_3.enabled = false
	$RayCast_3.force_raycast_update()
	$RayCast_4.enabled = false
	$RayCast_4.force_raycast_update()
	$RayCast_5.enabled = false
	$RayCast_5.force_raycast_update()

func _on_perception_body_entered(body):
	if body is Player:
		enablePerception(false)
		perceivedSomething = true
		perceivedLocation = body.global_position
		playerSawn = body
		
func enableAllCollitions(enabled:bool):
	$perception/CollisionShape2D.disabled = !enabled
	$Collision_Idle.disabled = !enabled
	$Collision_Attack .disabled = !enabled
	$explosionArea/Collision_Explosion.disabled = !enabled
	
func explode():
	$explosionArea/Collision_Explosion.disabled = false
	self.animation.play('explosion')
	
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'explosion':
		needRespawn = true

func rebirth():
	playerSawn = null
	perceivedLocation = Vector2.ZERO
	perceivedSomething = false
	needRespawn = false
	global_position = respawnposition
	animation.play("idle")


func _on_explosion_area_body_entered(body):
	if body is Player:
		body.dead = true 
		print("C muere")
