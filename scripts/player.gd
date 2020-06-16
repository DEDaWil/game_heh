extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("player_right"):
		$Animations.play("Run")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("player_left"):
		$Animations.play("Run")
		$Sprite.flip_h = true
	else:
		$Animations.play("Idle")
