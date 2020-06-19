extends KinematicBody2D

const Consts = preload("res://scripts/core/consts.gd");

# signals
signal death
signal health_change

# export
export (int) var speed = 100
export (int) var gravity = 1200
export (int) var health = 5

# vars
var velocity = Vector2()
var direction = Consts.Direction.Left
var attackedDirection = Consts.Direction.Left

func _ready():
	$HealthBar.value = health

func _physics_process(delta):
	if health > 0:
		if is_on_floor():
			velocity.x = 0
		if is_on_floor() && ($Animation.current_animation == "Walk" || $Animation.current_animation == ""):
			velocity.x = speed * direction
			$Animation.play("Walk")
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_wall() && is_on_floor():
		change_direction()

func change_direction():
	direction *= -1
	$Sprite.flip_h = !$Sprite.flip_h
	$AttackSprite.flip_h = !$AttackSprite.flip_h

func take_damage(damage, _direction):
	attackedDirection = _direction
	health -= damage
	emit_signal("health_change")

func _on_skeleton_death():
	set_collision_layer_bit(Consts.Layers.Enemy, false)
	velocity.x = 0
	$Animation.play("Death")


func _on_skeleton_health_change():
	if health <= 0:
		health = 0
		emit_signal("death")
	else:
		$Animation.stop()
		$Animation.play("TakingDamage")
		velocity.x = speed * attackedDirection
		velocity.y = -200
		velocity = move_and_slide(velocity, Vector2(0,-1))
	$HealthBar.value = health


func _on_AutoAttack_timeout():
	$Animation.play("Attack_" + String((randi() % 2) + 1))
