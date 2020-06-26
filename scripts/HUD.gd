extends Control

# onready
onready var HealthBar: TextureProgress = get_node("Health")
onready var FPS: Label = get_node("FPS")

func _process(delta):
	FPS.text = "fps: " + str(Engine.get_frames_per_second())

func _on_Player_update_hud(health: int):
	HealthBar.value = health
