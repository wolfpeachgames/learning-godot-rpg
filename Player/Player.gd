extends KinematicBody2D

const MAX_PLAYER_MOVEMENT_SPEED = 80
const ACCELERATION = 5000
const FRICTION = 900

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# get the state machine from the animation tree to control which animation should be playing
onready var animationState = animationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true


# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input_vector.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
