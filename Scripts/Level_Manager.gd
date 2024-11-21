extends Node2D
class_name LevelManager

static var _instance: LevelManager = null
var current_level: Level 
var levels_dict: Dictionary
var levels_name_Arr : Array

@onready var dynamic_apple : Area2D = $"../Items/apple"
@onready var dynamic_door : Area2D = $"../Items/Door"
@onready var dynamic_chest : Area2D = $"../Items/chest"

@export var player: Player
@export var levels_resource_group: ResourceGroup
@export var instanceLevel: PackedScene

func _ready():
	print("READY LEVELMANAGR")
	#if GlobalVar.is_host or !GlobalVar.is_online :
	GlobalVar.localAuth = str(get_multiplayer_authority())
	_load_levels()
	_get_current_level()
	levels_name_Arr.erase("level_Final")
	levels_name_Arr.erase("lobby")
	change_level_by_name("level_3")
	#change_level()
	
func _process(_delta):
	if GlobalVar.next_Level == true:
		print("Cambio de nivel : TRUE!")
		change_level()
	if GlobalVar.gameOver == true:
		print("GAMEOVER Level manager")
		get_tree().change_scene_to_file("res://Escenas/gameOver.tscn")
		
#	Public Methods
func change_level_by_name(level_name: String):
	print("change_level_by_name LEVELMANAGR")
	#levels_name_Arr.erase(level_name)

	if get_child_count() > 0:
		print("BORRA! : ",current_level)
		current_level.queue_free()
	
	current_level = _get_level_instance_by_key(level_name) as Level
	
	#Posiciona Jugadores
	print("players: ",GlobalVar.players)
	print("current_level: ",current_level)
	current_level.place_players()
	
	#Posiciona Manzana
	current_level.set_dynamic_apples(dynamic_apple)
	
	#Posiciona Puertas
	current_level.set_dynamic_doors(dynamic_door)
	
	#Posiciona Cofres
	current_level.set_dynamic_chests(dynamic_chest)
	
	#posicioa enemigos
	current_level.place_enemies()
	_set_level(current_level)
		
	
func change_level():
	GlobalVar.next_Level = false
	if levels_name_Arr.size() > 0:
		var random_level = levels_name_Arr[randi() % levels_name_Arr.size()]
		print("random_level: ",random_level)
		change_level_by_name(random_level)
	elif levels_name_Arr.size() == 0: 
		change_level_by_name("level_Final")

#	Private Methods
#Cargar niveles
func _load_levels():
	var packed_scene_levels: Array[PackedScene] = []
	levels_resource_group.load_all_into(packed_scene_levels)
	
	for level in packed_scene_levels:
		var level_name = _get_level_name_from_path(level.resource_path)
		levels_name_Arr.append(level_name)
		levels_dict[level_name] = level
	print("levels_Names: ",levels_name_Arr)

func _get_current_level() -> Level:
	if not get_child_count() > 0:
		print("Not level has been placed")
		return null
	current_level = get_child(0) as Level
	return current_level

func _set_level(level:Level):
	print("Set Levels: ",level)
	add_child(level)
	current_level = level

func _get_level_instance_by_key(key:String) -> Level:
	if not levels_dict.has(key):
		print("Scene with name "+key+" not found")
		return null
	var level = levels_dict[key].instantiate()
	return level

func _get_level_name_from_path(path:String)-> String:
	var file_name = path.get_file()
	return file_name.replace(".tscn","")

func _on_backgroundbass_finished():
	pass
	#$"../Sonidos/backgroundbass".play()
		

@rpc()
func changeLevel(level):
	pass
