extends KinematicBody2D

const MAX_PLAYER_MOVEMENT_SPEED = 100.0
const ACCELERATION = 5000
const FRICTION = 900

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
#func _ready():
#	print("Hello world")

# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_collide(velocity * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
