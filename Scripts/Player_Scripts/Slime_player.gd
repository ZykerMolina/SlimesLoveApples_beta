extends CharacterBody2D
class_name Player
var player : Player

var player_speed = 150
var player_jump_speed = -350
var input_axis : Vector2
var animation_Player
var respawn_position : Vector2
var dead : bool = false
var open : bool = false
var interactive_Obj : Area2D
var trampoline_mode : bool = false
var inmune : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var set_jumped_trampoline: bool = false

@onready var sprite = $Sprite2D
@onready var collision_body = $CollisionShape2D
@onready var collision_trampoline = $trampoline_area/Collision_trampoline
@onready var respawn_timer = $Timer
@onready var rayCastSlime = $RayCastSlime

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	var cam = $Camera2D
	$MultiplayerSynchronizer.set_multiplayer_authority(self.name.to_int())
	
func _process(_delta):
	$LabelState.text = $StateMachine.state.name + " " + str(self.global_position)
	if !is_multiplayer_authority() : return
	flip_Sprite()
	interact_With_Obj()
	lifes_ctrl()
	if global_position.y > 350 && !dead :
		dead = true
	
func _physics_process(delta):
	if !is_multiplayer_authority() : return
	
func flip_Sprite():
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
func is_dead():
	return dead

func respawn():
	self.position = respawn_position
	dead = false
	
	
func set_respawn_position(position:Vector2):
	respawn_position = position + Vector2(0,-50)

func teleport(position:Vector2):
	self.position = position 

func _on_apple_body_entered(body):
	print("COLISION PLAYER: ",body)
	$Sonidos/Swallw.play()

func interact_With_Obj():
	if Input.is_action_just_pressed("arriba"):
		if interactive_Obj is Door:
			interactive_Obj.interact(self)
		if interactive_Obj is Chest:
			interactive_Obj.interact(self)

func set_interactive_Obj(obj : Area2D):
	interactive_Obj = obj
	
func get_interactive_Obj():
	return get_interactive_Obj

func _on_trampoline_area_body_entered(body):
	if body is Player and body != self and !GlobalVar.players[body.name].stepedTrampoline:
		communicateTrampolineJump(body	.name, true)

func changeColor(color : String = "Yellow"):
	if  color == "Green":
		animation_Player = $Animations/AnimationPlayerGreen
	elif  color == "Blue":
		animation_Player = $Animations/AnimationPlayerBlue
	elif  color == "Red":
		animation_Player = $Animations/AnimationPlayerRed
	elif  color == "Yellow":
		animation_Player = $Animations/AnimationPlayerYellow

func kill_slime():
	respawn_timer.start()
	$Sonidos/death.play()
	damage_ctrl()

func jump(adition: int = 0):
	"res://Recursos/sonidos/jump.mp3"
	$Sonidos/jump.play()
	self.velocity.y = self.player_jump_speed + adition
	self.animation_Player.play("jump_up")

func trampolineJump():
	jump(-300)

func adjustPosition(delta):
	var directionx = Input.get_axis("izquierda","derecha")
	self.velocity.x = directionx * self.player_speed
	self.velocity.y += self.gravity * delta
	self.move_and_slide()
	
func walk():
	$Sonidos/Walk.play()
	self.animation_Player.play("walk")

func set_idle():
	self.velocity = Vector2.ZERO
	self.animation_Player.play("idle")
	self.setTrampolineColisionArea(false)
	$Sonidos/Walk.stop()
	

func setTrampolineColisionArea(active : bool = false):
	self.trampoline_mode = active
	if active :
		self.collision_body.position.y = -7
		self.collision_body.scale.x = 0.9
		self.collision_trampoline.set_deferred("disabled",false)
		self.animation_Player.play("trampoline_mode")
	else:
		self.collision_body.position.y = -9
		self.collision_body.scale.x = 1
		self.collision_trampoline.set_deferred("disabled",true)
	
func _on_timer_timeout():
	print("Respawn timer timeout")
	pass # Replace with function body.
	
func communicateTrampolineJump(slime: String, state: bool):
	if GlobalVar.is_online :
		GlobalVar.players[slime].stepedTrampoline = state
		jumpSync.rpc(slime, state)

func lifes_ctrl():
	if GlobalVar.life_apples == 3:
		$LifeBar/Lifes/apple.visible = true
		$LifeBar/Lifes/apple2.visible = true
		$LifeBar/Lifes/apple3.visible = true
	if GlobalVar.life_apples == 2:
		$LifeBar/Lifes/apple.visible = true
		$LifeBar/Lifes/apple2.visible = true
		$LifeBar/Lifes/apple3.visible = false
	if GlobalVar.life_apples == 1:
		$LifeBar/Lifes/apple.visible = true
		$LifeBar/Lifes/apple2.visible = false
		$LifeBar/Lifes/apple3.visible = false
	if GlobalVar.life_apples == 0:
		$LifeBar/Lifes/apple.visible = false
		$LifeBar/Lifes/apple2.visible = false
		$LifeBar/Lifes/apple3.visible = false


func damage_ctrl():
	if GlobalVar.life_apples > 0:
		GlobalVar.life_apples -= 1
	if GlobalVar.life_apples <= 0:
		GlobalVar.gameOver = true
		print("GAMEOVER")
	print("vidas Local: ",GlobalVar.life_apples)
	lifesSync.rpc(GlobalVar.life_apples)

@rpc("any_peer","call_remote" ,"reliable")
func jumpSync(jumpingSlime : String, jumpstate: bool):
	GlobalVar.players[jumpingSlime].stepedTrampoline = jumpstate

@rpc("any_peer","call_remote" ,"reliable")
func lifesSync(lifes: int):
	GlobalVar.life_apples = lifes
	if GlobalVar.life_apples == 0 :
		GlobalVar.gameOver = true

func set_jumped_over_trampoline(trampoline:bool):
	set_jumped_trampoline = trampoline
