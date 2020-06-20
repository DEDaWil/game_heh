extends Control

# onready
onready var HealthBar: TextureProgress = get_node("Health")

func _on_Player_update_hud(health: int):
	HealthBar.value = health
