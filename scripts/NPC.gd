extends KinematicBody2D

const Bubble = preload("res://scenes/dialogue_bubble.tscn")

onready var Player = get_node("../Player")

var bubble: Node2D = null

func _process(_delta):
	if bubble == null:
		bubble = Bubble.instance()
		get_parent().add_child(bubble)
		bubble.get_node("VBoxContainer/Label").text = "Please,\nkill him!"
		bubble.position = position + Vector2(-bubble.get_node("VBoxContainer").rect_size.x / 2.0, -$Sprite.texture.get_height() - bubble.get_node("VBoxContainer").rect_size.y - 40)
