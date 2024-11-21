extends Area2D
class_name Chest

var realChest : bool = false
var floor : int
var numberChest : int
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("idle")
	
func _on_body_entered(body):
	if body is Player:
		body.set_interactive_Obj(self)
		
func _on_body_exited(body):
	if body is Player:
		body.set_interactive_Obj(null)

func set_real(real:bool):
	realChest = real

func isReal():
	return realChest

func get_Floor():
	return floor

func set_Floor(floorVar):
	floor = floorVar
	
func get_number_Chest():
	return numberChest
	
func set_number_Chest(numberChestVar):
	numberChest = numberChestVar
	

func interact(body:Player):
	print("INTERACTUA")
	$open.play()
	anim.play("open_true")
	body.set_physics_process(false)
	await (anim.animation_finished)
	body.set_physics_process(true)
	GlobalVar.next_Level = true
	print("MANZANA !")
#	if isReal():
#		anim.play("open_true")
#		body.set_physics_process(false)
#		await (anim.animation_finished)
#		body.set_physics_process(true)
#		GlobalVar.next_Level = true
#		print("MANZANA !")
#	if not isReal():
#		anim.play("open")
#		body.set_physics_process(false)
#		await (anim.animation_finished)
#		body.set_physics_process(true)
		
	#anim.play("idle")
	#$close.play()
	#await (anim.animation_finished)

