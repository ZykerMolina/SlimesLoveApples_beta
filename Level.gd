extends Node
class_name Level

#Levl Signals
signal intro_animation_started
signal intro_animation_completed

@export var player_initial_position_marker2D: Node2D
@export var apples_position_marker2D: Array[Node2D]
@export var doors_position_marker2D: Array[Node2D]
@export var chests_position_marker2D: Array[Node2D]
@export var TeleportPoints: Array[Node2D]

#@onready var level_ui:LevelUI= %levelUI:
#	set(value):
#		level_ui = value
#		level_ui.animation_started.connect(func():emit_signal(("intro_animation_started")))
#		level_ui.animation_completed.connect(func():emit_signal(("intro_animation_completed")))

func _ready():
	pass
#	print("Level")
#	print("player_initial_position_marker2D: ", player_initial_position_marker2D.global_position)
	#Fade Animation
	#if level_ui:
	#	level_ui.play()
	
func set_player_position(player:Player):
	#player.set_respawn_position(player_initial_position_marker2D.global_position)
	player.global_position = player_initial_position_marker2D.global_position

func set_dynamic_apples(appleObject:Apple):
	for apple in apples_position_marker2D:
		var appleRef = load("res://Escenas/Items/apple.tscn")
		var apple_child = appleRef.instantiate()
		#print(JSON.parse_string(apple.editor_description))
		#var apple_child = appleObject.duplicate()
		apple_child.global_position = apple.global_position
		add_child(apple_child)

func set_dynamic_doors(doorObject:Door):
	var JLevel = JSON.parse_string(self.editor_description)
	
	if doors_position_marker2D.size() > 0:
		var numMaxRandDoors = JLevel.numMaxRandDoors
		var trueDoorPerFloor : Array
		
		for number in range(4):
			#var random_number = numberFloor[randi() % numberFloor.size()]
			var random_number = randi_range(1,numMaxRandDoors)
			#print("Numero Random: ",random_number)
			trueDoorPerFloor.append(random_number)
		print("trueDoorPerFloor: ",trueDoorPerFloor)
		for door in doors_position_marker2D:
			var door_child = doorObject.duplicate()
			door_child.global_position = door.global_position
			var JDoor = JSON.parse_string(door.editor_description)
			door_child.set_Floor(JDoor.floor)
			if "number" in JDoor:
				door_child.set_number_Door(JDoor.number)
			var realDoorNumber = trueDoorPerFloor[door_child.get_Floor()-1]
			if realDoorNumber == door_child.get_number_Door():
				door_child.set_real(true)
				door_child.set_teleportPoint(TeleportPoints[door_child.get_Floor()-1])
			else:
				door_child.set_teleportPoint(player_initial_position_marker2D)
			#print("RETURN_ ",door_child.get_Floor(),door_child.get_number_Door(),door_child.isReal())
			add_child(door_child)

func set_dynamic_chests(chestObject:Chest):
	var JLevel = JSON.parse_string(self.editor_description)
	if chests_position_marker2D.size() > 0:
		var numMaxRandChests = JLevel.numMaxRandChests
		var trueChestPerFloor : Array
		for number in range(1):
			#var random_number = numberChests[randi() % numberChests.size()]
			var random_number = randi_range(1,numMaxRandChests)
			#print("Numero Random: ",random_number)
			trueChestPerFloor.append(random_number)
		print("trueChestPerFloor: ",trueChestPerFloor)
		for chest in chests_position_marker2D:
			var chest_child = chestObject.duplicate()
			chest_child.global_position = chest.global_position
			var JChest = JSON.parse_string(chest.editor_description)
			chest_child.set_Floor(JChest.floor)
			if "number" in JChest:
				chest_child.set_number_Chest(JChest.number)
			var realChestsNumber = trueChestPerFloor[chest_child.get_Floor()-1]
			if realChestsNumber == chest_child.get_number_Chest():
				chest_child.set_real(true)
			#print("RETURN_ ",chest_child.get_Floor(),chest_child.get_number_Chest(),chest_child.isReal())
			add_child(chest_child)
			
func place_players():
	var c = 0
	for player in GlobalVar.players:
		var playerRes = load("res://Escenas/slime_player.tscn")
		var slime : Player = playerRes.instantiate()
		var initialPosition : Marker2D = get_node("Initial Position")
		slime.global_position = Vector2(initialPosition.global_position.x, initialPosition.global_position.y - (c*10))
		c+=1
		slime.changeColor(GlobalVar.players[player].color)
		slime.name = GlobalVar.players[player].id
		slime.set_multiplayer_authority(slime.name.to_int())
		#slime.call_defered("set_multiplayer_authority",slime.name.to_int())
		add_child(slime, true)
		
func place_enemies():
	var initialPosition : Node = get_node("enemies")
	if initialPosition != null:
		for enemyMrkr in initialPosition.get_children():
			print("FOR")
			if enemyMrkr is Marker2D:
				var enemyRes = load("res://Escenas/fire_spirit.tscn")
				var enemy : FireSpirit = enemyRes.instantiate()
				enemy.global_position = enemyMrkr.global_position
				enemy.respawnposition = enemyMrkr.global_position
				add_child(enemy, true)
