extends KinematicBody2D

var velocity = Vector2.ZERO
var PLAYER_MOVEMENT_SPEED = 2.0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	print("Hello world")

# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * PLAYER_MOVEMENT_SPEED
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * PLAYER_MOVEMENT_SPEED

	if (input_vector != Vector2.ZERO):
		print(input_vector)
	velocity = input_vector if (input_vector != Vector2.ZERO) else Vector2.ZERO

	# if Input.is_action_pressed("ui_right"):
	# 	velocity.x = PLAYER_MOVEMENT_SPEED
	# elif Input.is_action_pressed("ui_left"):
	# 	velocity.x = -PLAYER_MOVEMENT_SPEED
	# elif Input.is_action_pressed("ui_up"):
	# 	velocity.y = -PLAYER_MOVEMENT_SPEED
	# elif Input.is_action_pressed("ui_down"):
	# 	velocity.y = PLAYER_MOVEMENT_SPEED
	# else:
	# 	velocity.x = 0
	# 	velocity.y = 0

	move_and_collide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
