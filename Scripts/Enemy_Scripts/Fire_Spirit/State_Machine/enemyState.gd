class_name EnemyState
extends State

var fireSpirit : FireSpirit

func _ready():
	await (owner.ready)
	fireSpirit = owner as FireSpirit
	assert(fireSpirit != null)
