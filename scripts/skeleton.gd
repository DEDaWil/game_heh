extends KinematicBody2D

const Consts = preload("res://scripts/core/consts.gd");

# signals
signal death
signal health_change

# export
export (int) var speed = 100
export (int) var gravity = 1200
export (int) var health = 5
export (int) var damage = 1

# onready
onready var Sprite: Sprite = get_node("Sprite")
onready var Animations: AnimationPlayer = get_node("Animations")
onready var HealthBar: TextureProgress = get_node("HealthBar")
onready var AttackArea: RayCast2D = get_node("AttackRaycast")

# vars
var velocity = Vector2()
var direction = Consts.Direction.Left
var attackedDirection = Consts.Direction.Left
var state = Consts.BodyState.Idle

func _ready():
	HealthBar.value = health

func _physics_process(delta):
	_process_AI()
	_process_raycasting()
	_process_state()

	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _process_AI():
	if health > 0 && (state == Consts.BodyState.Move || state == Consts.BodyState.Idle):
		if is_on_floor():
			state = Consts.BodyState.Move
			if is_on_wall():
				direction *= -1
				AttackArea.cast_to.x = direction * abs(AttackArea.cast_to.x)

func _process_state():
	match state:
		Consts.BodyState.None:
			if is_on_floor():
				velocity.x = 0
		Consts.BodyState.Attack:
			Animations.play("Attack_" + String((randi() % 2) + 1))
			velocity.x = 0
			state = Consts.BodyState.None
		Consts.BodyState.Idle:
			#$Animations.play("Idle")
			velocity.x = 0
		Consts.BodyState.TakeDamage:
			Animations.play("TakingDamage")
			velocity.x = speed * attackedDirection
			velocity.y = -200
			state = Consts.BodyState.None
		Consts.BodyState.Death:
			Animations.play("Death")
			velocity.x = 0
			state = Consts.BodyState.Dead
		Consts.BodyState.Move:
			Animations.play("Walk")
			Sprite.flip_h = direction == Consts.Direction.Left
			velocity.x = direction * speed

func _process_raycasting():
	if AttackArea.enabled:
		var target = AttackArea.get_collider()
		if target != null:
			if target.has_method("take_damage"):
				target.take_damage(damage, direction)
				AttackArea.enabled = false

func take_damage(damage: int, _direction):
	attackedDirection = _direction
	health -= damage
	emit_signal("health_change")

func _on_skeleton_death():
	set_collision_layer_bit(Consts.Layers.Enemy, false)
	state = Consts.BodyState.Death

func _on_skeleton_health_change():
	if health <= 0:
		health = 0
		emit_signal("death")
	else:
		state = Consts.BodyState.TakeDamage
	HealthBar.value = health

func _on_AutoAttack_timeout():
	if state == Consts.BodyState.Move:
		state = Consts.BodyState.Attack

func _on_Animations_animation_finished(anim_name: String):
	if anim_name.begins_with("Attack") || anim_name == "TakingDamage":
		state = Consts.BodyState.Idle
