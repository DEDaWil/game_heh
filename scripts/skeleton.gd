extends KinematicBody2D

# export
export (int) var speed = 200
export (int) var gravity = 500
export (int) var health = 2

# vars
var velocity = Vector2()
var direction = 1

func kill():
	velocity.x = 0
	$CollisionShape2D.disabled = true #проблемес
	$Animation.play("Death")

func _physics_process(delta):
	if health > 0:
		velocity.x = speed * direction
		$Animation.play("Walk")
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall():
		change_direction()

func change_direction():
	direction *= -1
	$Sprite.flip_h = !$Sprite.flip_h
