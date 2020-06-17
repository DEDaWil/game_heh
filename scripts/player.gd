extends KinematicBody2D

# export
export (int) var run_speed = 100
export (int) var gravity = 1200
export (int) var jump = 500

# vars
var velocity = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("player_hit"):
		$Animations.play("Hit")
		velocity.x = 0
	
	if $Animations.current_animation != "Hit":
		if Input.is_action_pressed("player_right"):
			$Animations.play("Run")
			$Sprite.flip_h = false
			velocity.x = run_speed
		elif Input.is_action_pressed("player_left"):
			$Animations.play("Run")
			$Sprite.flip_h = true
			velocity.x = -run_speed
		else:
			$Animations.play("Idle")
			velocity.x = 0
			
	if Input.is_action_pressed("player_up") && is_on_floor():
		velocity.y = -jump
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
