extends Node2D

onready var player = get_node("../Player")

func _process(delta):
	position.x = player.position.x
