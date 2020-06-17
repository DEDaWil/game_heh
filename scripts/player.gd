extends KinematicBody2D

const SPEED = 200
const FLOOR = Vector2(0, -1)

var is_hit = false
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_hit == true:
		return
	
	if Input.is_action_just_pressed("player_hit") && is_hit == false:
		is_hit == true
		$Animations.play("Hit")
	
	if Input.is_action_pressed("player_right"):
		$Animations.play("Run")
		$Sprite.flip_h = false
		velocity.x = SPEED
	elif Input.is_action_pressed("player_left"):
		$Animations.play("Run")
		$Sprite.flip_h = true
		velocity.x = -SPEED
	else:
		$Animations.play("Idle")
		velocity.x = 0
	
	velocity = move_and_slide(velocity, FLOOR)

func _on_Animations_animation_finished():
	if $Animations.has_playing("Hit"):
		is_hit = false
