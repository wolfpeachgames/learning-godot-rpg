extends KinematicBody2D

enum {
	MOVE_STATE,
	IDLE_STATE
}

const CONTROL_UP = "ui_up"
const CONTROL_DOWN = "ui_down"
const CONTROL_LEFT = "ui_left"
const CONTROL_RIGHT = "ui_right"

const WALK_ANIMATION = "PlayerWalkAnimation"

export var MAX_PLAYER_MOVEMENT_SPEED = 75
const ACCELERATION = 5000
const FRICTION = 900

var state = MOVE_STATE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# get the state machine from the animation tree to control which animation should be playing
onready var animationState = animationTree.get("parameters/playback")


func _process(delta):
	match state:
		MOVE_STATE:
			do_move_state(delta)
		IDLE_STATE:
			do_idle_state()


func do_move_state(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength(CONTROL_RIGHT) - Input.get_action_strength(CONTROL_LEFT))
	input_vector.y = (Input.get_action_strength(CONTROL_DOWN) - Input.get_action_strength(CONTROL_UP))
	input_vector = input_vector.normalized()
	
	if (input_vector != Vector2.ZERO):
#		set_animation_blend_positions(input_vector) # update direction for all animations
#		animationState.travel(WALK_ANIMATION) # initiate running animation
		if (input_vector.x > 0):
			animationPlayer.play("PlayerWalkRightAnimation")
		elif (input_vector.x < 0):
			animationPlayer.play("PlayerWalkLeftAnimation")
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("PlayerIdleLeftAnimation")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()


func do_idle_state() -> void:
	pass
	
	
func move() -> void:
	velocity = move_and_slide(velocity)
