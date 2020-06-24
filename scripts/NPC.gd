extends Area2D

const Bubble = preload("res://scenes/dialogue_bubble.tscn")

var bubble: Node2D = null
var updateLayout: bool = false;

func _process(_delta):
	if updateLayout:
		updateLayout = false
		var bubble_sprite: NinePatchRect = bubble.get_node("VBoxContainer/Label/NinePatchRect")
		bubble.position = position + Vector2(-bubble_sprite.rect_size.x / 2.0, -$Sprite.texture.get_height() / 2.0 * scale.y - bubble_sprite.rect_size.y - 10)
	if bubble == null:
		bubble = Bubble.instance()
		get_parent().add_child(bubble)
		bubble.get_node("VBoxContainer/Label").text = "Please,\nkill him!"
		updateLayout = true;
