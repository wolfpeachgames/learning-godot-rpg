extends KinematicBody2D

const MAX_PLAYER_MOVEMENT_SPEED = 80
const ACCELERATION = 5000
const FRICTION = 900

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass


# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		animationPlayer.play(getMovementAnimationFromVector(input_vector))
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("PlayerIdleDown")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass

func getMovementAnimationFromVector(vector):
	var animation = "PlayerIdleDown"
	if (vector.y < 0):
		animation = "PlayerRunUp"
	elif (vector.y > 0):
		animation = "PlayerRunDown"
	if (vector.x < 0):
		animation = "PlayerRunLeft"
	elif (vector.x > 0):
		animation = "PlayerRunRight"
	return animation
