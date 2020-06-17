extends KinematicBody2D

export (int) var speed = 200
export (int) var gravity = 500

var velocity = Vector2()
var direction = 1

func _physics_process(delta):
	velocity.x = speed * direction
	$AnimationPlayer.play("walk")
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall():
		change_direction()

func change_direction():
	direction *= -1
	$Sprite.flip_h = !$Sprite.flip_h
