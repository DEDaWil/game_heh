extends KinematicBody2D

const Consts = preload("res://scripts/core/consts.gd")

# signals
signal update_hud(health)
signal death

# export
export (int) var run_speed = 100
export (int) var gravity = 1200
export (int) var jump = 500
export (int) var damage = 1
export (int) var health = 3

# onready
onready var Sprite: Sprite = get_node("Sprite")
onready var Animations: AnimationPlayer = get_node("Animations")
onready var AttackArea: RayCast2D = get_node("AttackRaycast")

# vars
var velocity = Vector2()
var direction = Consts.Direction.Left
var state = Consts.BodyState.Idle
var attackedDirection = Consts.Direction.Left

func _ready():
	emit_signal("update_hud", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_process_input()
	_process_raycasting()
	_process_state()

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _process_input():
	if state == Consts.BodyState.TakeDamage || state == Consts.BodyState.None || is_dead():
		return
	if Input.is_action_just_pressed("player_hit") && is_on_floor():
		state = Consts.BodyState.Attack

	if state != Consts.BodyState.Attack:
		if Input.is_action_pressed("player_right"):
			state = Consts.BodyState.Run
			direction = Consts.Direction.Right
		elif Input.is_action_pressed("player_left"):
			state = Consts.BodyState.Run
			direction = Consts.Direction.Left
		else:
			state = Consts.BodyState.Idle
		if Input.is_action_pressed("player_up") && is_on_floor():
			state = Consts.BodyState.Jump

func _process_state():
	match state:
		Consts.BodyState.None:
			if is_on_floor():
				velocity.x = 0
				state = Consts.BodyState.Idle
		Consts.BodyState.Attack:
			Animations.play("Attack")
			velocity.x = 0
		Consts.BodyState.Idle:
			Animations.play("Idle")
			velocity.x = 0
		Consts.BodyState.Jump:
			velocity.y = -jump
		Consts.BodyState.Death:
			Animations.play("Death")
			velocity.x = 0
			set_collision_layer_bit(Consts.Layers.Player, false)
			state = Consts.BodyState.Dead
		Consts.BodyState.TakeDamage:
			velocity.x = run_speed / 2 * attackedDirection
			velocity.y = -200
			state = Consts.BodyState.None
		Consts.BodyState.Run:
			run()

func run():
	Animations.play("Run")
	AttackArea.cast_to.x = direction * abs(AttackArea.cast_to.x)
	Sprite.flip_h = direction == -1
	velocity.x = direction * run_speed

func is_dead() -> bool:
	return state == Consts.BodyState.Death || state == Consts.BodyState.Dead

func take_damage(_damage: int, _direction):
	attackedDirection = _direction
	health -= _damage
	state = Consts.BodyState.TakeDamage
	if health <= 0:
		health = 0
		emit_signal("death")
		state = Consts.BodyState.Death
	emit_signal("update_hud", health)

func _process_raycasting():
	if AttackArea.enabled:
		var target = AttackArea.get_collider()
		if target != null:
			if target.has_method("take_damage"):
				target.take_damage(damage, direction)
				AttackArea.enabled = false

func _on_Animations_animation_finished(anim_name: String):
	if anim_name == "Attack":
		state = Consts.BodyState.Idle
