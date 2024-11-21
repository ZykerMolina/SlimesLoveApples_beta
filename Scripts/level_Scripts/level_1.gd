extends Level
#class_name level_1

func _ready():
	$Label.text = str(get_multiplayer_authority())
