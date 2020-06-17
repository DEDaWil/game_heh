extends KinematicBody2D

# consts
const SPEED = 200

# vars
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("player_hit"):
		$Animations.play("Hit")
		velocity.x = 0
	
	if $Animations.current_animation != "Hit":
		if Input.is_action_pressed("player_right"):
			$Animations.play("Run")
			$Sprite.flip_h = false
			velocity.x = SPEED
		elif Input.is_action_pressed("player_left"):
			$Animations.play("Run")
			$Sprite.flip_h = true
			velocity.x = -SPEED
		else:
			$Animations.play("Idle")
			velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
