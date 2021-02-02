extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

const MAX_PLAYER_MOVEMENT_SPEED = 75
const ACCELERATION = 5000
const FRICTION = 900
const PLAYER_ROLL_SPEED = 110

const CONTROL_UP = "ui_up"
const CONTROL_DOWN = "ui_down"
const CONTROL_LEFT = "ui_left"
const CONTROL_RIGHT = "ui_right"
const CONTROL_ATTACK = "attack"
const CONTROL_ROLL = "roll"

const RUN_ANIMATION = "Run"
const ATTACK_ANIMATION = "Attack"
const IDLE_ANIMATION = "Idle"
const ROLL_ANIMATION = "Roll"

const BLEND_POSTITION_TEMPLATE_STRING = "parameters/%s/blend_position"
const ATTACK_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % ATTACK_ANIMATION
const IDLE_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % IDLE_ANIMATION
const RUN_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % RUN_ANIMATION
const ROLL_BLEND_POSTION = BLEND_POSTITION_TEMPLATE_STRING % ROLL_ANIMATION

enum {
	MOVE_STATE,
	ROLL_STATE,
	ATTACK_STATE
}

var state = MOVE_STATE
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# get the state machine from the animation tree to control which animation should be playing
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox


# Called when the node enters the scene tree for the first time.
func _ready():
	# should connect to player death functionality eventually rather than queue_free
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		MOVE_STATE:
			move_state(delta)
		ROLL_STATE:
			roll_state()
		ATTACK_STATE:
			attack_state()


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = (Input.get_action_strength(CONTROL_RIGHT) - Input.get_action_strength(CONTROL_LEFT))
	input_vector.y = (Input.get_action_strength(CONTROL_DOWN) - Input.get_action_strength(CONTROL_UP))
	input_vector = input_vector.normalized()

	if (input_vector != Vector2.ZERO):
		roll_vector = input_vector # save roll direction
		swordHitbox.knockback_vector = input_vector # save direction to knockback NPCs
		set_animation_blend_positions(input_vector) # update direction for all animations
		animationState.travel(RUN_ANIMATION) # initiate running animation
		velocity = velocity.move_toward(input_vector * MAX_PLAYER_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		animationState.travel(IDLE_ANIMATION)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if (Input.is_action_just_pressed(CONTROL_ROLL)):
		# hurtbox.start_invincibility(1.0)
		state = ROLL_STATE
		

	if (Input.is_action_just_pressed(CONTROL_ATTACK)):
		state = ATTACK_STATE


func attack_state():
	velocity = Vector2.ZERO
	animationState.travel(ATTACK_ANIMATION)


func roll_state():
	velocity = roll_vector * PLAYER_ROLL_SPEED
	animationState.travel(ROLL_ANIMATION)
	move()


func set_animation_blend_positions(vector):
	animationTree.set(IDLE_BLEND_POSTION, vector)
	animationTree.set(RUN_BLEND_POSTION, vector)
	animationTree.set(ATTACK_BLEND_POSTION, vector)
	animationTree.set(ROLL_BLEND_POSTION, vector)


func attack_animation_finished():
	state = MOVE_STATE


func roll_animation_finished():
	state = MOVE_STATE


func move():
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	# print(hurtbox.monitorable)
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
