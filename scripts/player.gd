extends KinematicBody2D

var Consts = preload("res://scripts/core/consts.gd")

signal update_hud(health)

# export
export (int) var run_speed = 100
export (int) var gravity = 1200
export (int) var jump = 500
export (int) var damage = 1
export (int) var health = 3

# vars
var velocity = Vector2()
var direction = Consts.Direction.Left

func _ready():
	emit_signal("update_hud", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("player_hit"):
		$Animations.play("Hit")
		velocity.x = 0

	if $Animations.current_animation != "Hit":
		if Input.is_action_pressed("player_right"):
			run(Consts.Direction.Left)
		elif Input.is_action_pressed("player_left"):
			run(Consts.Direction.Right)
		else:
			$Animations.play("Idle")
			velocity.x = 0
			
		if Input.is_action_pressed("player_up") && is_on_floor():
			velocity.y = -jump

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

	detect_weapon_raycasting()

func run(_direction):
	direction = _direction
	$Animations.play("Run")
	$RayCast2D.cast_to.x = direction * abs($RayCast2D.cast_to.x)
	$Sprite.flip_h = direction == -1
	velocity.x = direction * run_speed

func detect_weapon_raycasting():
	if $RayCast2D.enabled:
		var target = $RayCast2D.get_collider()
		if target != null:
			if target.has_method("take_damage"):
				target.take_damage(damage, direction)
				$RayCast2D.enabled = false
