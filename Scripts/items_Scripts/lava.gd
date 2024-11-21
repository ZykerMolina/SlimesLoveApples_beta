@tool
class_name Lava extends Path2D

@onready var lavaArea2D = $lavaArea2D
@onready var pathFollow2D = $PathFollow2D
var lavaSpeed: float = .1

func _process(delta):
	lavaArea2D.global_position = pathFollow2D.global_position
	if pathFollow2D.progress_ratio < 1:
		pathFollow2D.progress_ratio += lavaSpeed * delta
	else:
		pathFollow2D.progress_ratio = 0

func _on_lava_area_2d_body_entered(body):
	if body is Player:
		print("MUERTO por lava !!!")
		body.dead = true
