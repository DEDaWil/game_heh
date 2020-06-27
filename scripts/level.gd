extends Node

func _on_Exit_body_entered(body: Node):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://scenes/level_2.tscn")

func _on_Player_death():
	$Music/MusicFade.interpolate_property($Music/MainMusic, "volume_db", -10, -60, 3.00)
	$Music/MusicFade.start()
	$LevelRestartTimer.start()

func _on_LevelRestartTimer_timeout():
	get_tree().reload_current_scene()

func _on_MusicFade_tween_completed(object, key):
	object.stop()
