extends KinematicBody2D

const constants = preload("res://scripts/core/consts.gd");

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
			print ("0")
		elif is_on_floor():
			velocity.x = speed * direction
			$Animation.play("Walk")
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall() && is_on_floor():
		change_direction()

func change_direction():
	direction *= -1
	$Sprite.flip_h = !$Sprite.flip_h

func take_damage(damage, _direction):
	velocity.x = speed * _direction
	velocity.y = -200
	health -= damage
	emit_signal("health_change")

func _on_skeleton_death():
	set_collision_layer_bit(constants.Layers.Enemy, false)
	velocity.x = 0
	$Animation.play("Death")


func _on_skeleton_health_change():
	if health <= 0:
		health = 0
		emit_signal("death")
	else:
		$Animation.stop()
		$Animation.play("TakingDamage")
	$HealthBar.value = health
