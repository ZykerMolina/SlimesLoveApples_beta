extends Area2D
class_name Door

@onready var anim = $AnimationPlayer
@onready var collision = $CollisionShape2D
var realDoor : bool = false
var floor : int
var numberDoor : int
var teleportPoint : Node2D

func _ready():
	anim.play("close")

func _on_body_entered(body):
	if body is Player :
		body.set_interactive_Obj(self)
		#print("Interaccion con puerta")
	else:
		anim.play("idle")
		
func _on_body_exited(body):
	if body is Player :
		body.set_interactive_Obj(null)

func set_real(real:bool):
	realDoor = real
	
func isReal():
	return realDoor

func get_Floor():
	return floor

func set_Floor(floorVar):
	floor = floorVar
	
func get_number_Door():
	return numberDoor
	
func set_number_Door(numberDoorVar):
	numberDoor = numberDoorVar
	
func get_teleportPoint():
	return teleportPoint
	
func set_teleportPoint(newPoint: Node2D):
	teleportPoint = newPoint

func interact(body:Player):
	anim.play("open")
	body.set_physics_process(false)
	await (anim.animation_finished)
	anim.play("close")
	await (anim.animation_finished)
	body.set_physics_process(true)
	if teleportPoint != null:
		body.teleport(teleportPoint.position)
