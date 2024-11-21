extends Camera2D

func _ready():
	top_level = true
	if is_multiplayer_authority():
		self.make_current()
	#global_position.y = 130

	
func _process(_delta):
	global_position.x = get_parent().global_position.x
	global_position.y = get_parent().global_position.y - 50
	#global_position = get_parent().global_position
