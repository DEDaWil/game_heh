extends KinematicBody2D

# signals
signal death
signal health_change

# export
export (int) var speed = 200
export (int) var gravity = 1200
export (int) var health = 5

# vars
var velocity = Vector2()
var direction = 1

func _ready():
	emit_signal("health_change")

func _physics_process(delta):
	if health > 0:
		if $Animation.current_animation == "TakingDamage":
			velocity.x = 100 * direction
			if is_on_floor():
				velocity.y = -200
		else:
			velocity.x = speed * direction
			$Animation.play("Walk")
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall():
		change_direction()

func change_direction():
	direction *= -1
	$Sprite.flip_h = !$Sprite.flip_h

func take_damage(damage):
	$Animation.play("TakingDamage")
	health -= damage
	emit_signal("health_change")
	if health <= 0:
		health = 0
		emit_signal("death")

func _on_skeleton_death():
	velocity.x = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$Animation.play("Death")


func _on_skeleton_health_change():
	$HealthBar.value = health
