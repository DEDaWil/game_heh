extends Node

func _on_Exit_body_entered(body: Node):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://scenes/level_2.tscn")

func _on_Player_death():
	$LevelRestartTimer.start()

func _on_LevelRestartTimer_timeout():
	get_tree().reload_current_scene()
