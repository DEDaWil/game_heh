extends KinematicBody2D

const SPEED = 200
const FLOOR = Vector2(0,-1)
const GRAVITY = 500

var velocity = Vector2()
var direction = 1

func _physics_process(delta):
	velocity.x = SPEED * direction
	$AnimatedSprite.play("Walk")
	velocity.y += (GRAVITY * delta)
	velocity = move_and_slide(velocity, FLOOR)
	
