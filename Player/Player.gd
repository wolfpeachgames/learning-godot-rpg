extends KinematicBody2D

const MAX_PLAYER_MOVEMENT_SPEED = 80
const ACCELERATION = 5000
const FRICTION = 900

const CONTROL_UP = "ui_up"
const CONTROL_DOWN = "ui_down"
const CONTROL_LEFT = "ui_left"
const CONTROL_RIGHT = "ui_right"
const CONTROL_ATTACK = "attack"

const RUN_ANIMATION = "Run"
const ATTACK_ANIMATION = "Attack"
const IDLE_ANIMATION = "Idle"

const BLEND_POSTITION_TEMPLATE_STRING = "parameters/%s/blend_position"
const ATTACK_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % ATTACK_ANIMATION
const IDLE_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % IDLE_ANIMATION
const RUN_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % RUN_ANIMATION

enum {
	MOVE_STATE,
	ROLL_STATE,
	ATTACK_STATE
}

var state = MOVE_STATE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# get the state machine from the animation tree to control which animation should be playing
onready var animationState = animationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		MOVE_STATE:
			move_state(delta)
		ROLL_STATE:
			roll_state(delta)
		ATTACK_STATE:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength(CONTROL_RIGHT) - Input.get_action_strength(CONTROL_LEFT))
	input_vector.y = (Input.get_action_strength(CONTROL_DOWN) - Input.get_action_strength(CONTROL_UP))
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		set_animation_blend_positions(input_vector)
		animationState.travel(RUN_ANIMATION)
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		animationState.travel(IDLE_ANIMATION)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed(CONTROL_ATTACK):
		state = ATTACK_STATE


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel(ATTACK_ANIMATION)


func roll_state(delta):
	pass


func set_animation_blend_positions(vector):
	animationTree.set(IDLE_BLEND_POSTION, vector)
	animationTree.set(RUN_BLEND_POSTION, vector)
	animationTree.set(ATTACK_BLEND_POSTION, vector)


func attack_animation_finished():
	state = MOVE_STATE


# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
# func _physics_process(delta):
# 	pass
