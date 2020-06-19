extends KinematicBody2D

# export
export (int) var run_speed = 100
export (int) var gravity = 1200
export (int) var jump = 500

# vars
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Weapon/CollisionShape2D.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("player_hit"):
		$Animations.play("Hit")
		velocity.x = 0
	
	if $Animations.current_animation != "Hit":
		if Input.is_action_pressed("player_right"):
			$Animations.play("Run")
			$Weapon/CollisionShape2D.position.x = abs($Weapon/CollisionShape2D.position.x)
			$Sprite.flip_h = false
			velocity.x = run_speed
		elif Input.is_action_pressed("player_left"):
			$Animations.play("Run")
			$Weapon/CollisionShape2D.position.x = abs($Weapon/CollisionShape2D.position.x) * -1
			$Sprite.flip_h = true
			velocity.x = -run_speed
		else:
			$Animations.play("Idle")
			velocity.x = 0
			
	if Input.is_action_pressed("player_up") && is_on_floor():
		velocity.y = -jump
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_Weapon_body_entered(body):
	if body.has_method("kill"):
		body.health -= 1
		if body.health <= 0:
			body.kill()
