extends Node2D

onready var player = get_node("../Player")

func _process(_delta):
	position.x = player.position.x
