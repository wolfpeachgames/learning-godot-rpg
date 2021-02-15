extends Node2D

export var ACCELERATION = 250
export var FRICTION = 100
export var MAX_MOVEMENT_SPEED = 45
export var WANDER_BUFFER = 3

enum { CROW_IDLE_STATE, CROW_TAKEOFF_STATE, CROW_WANDER_STATE }

const CROW_IDLE_ANIMATION = "CrowIdle"
const CROW_TAKEOFF_ANIMATION = "CrowTakeoff"
const CROW_FLY_ANIMATION = "CrowFly"

onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()

var velocity = Vector2.ZERO
var state = CROW_IDLE_STATE


func _ready():
	# add a small random delay to the beginning of the looping animation so that all crows aren't moving in syncrony
	rng.randomize()
	rng = rng.randf_range(0.0, 1.0)
	yield(get_tree().create_timer(rng), "timeout")
	animationPlayer.play(CROW_IDLE_ANIMATION)


func _process(delta: float) -> void:
	check_for_player()
	match state:
		CROW_IDLE_STATE:
			do_idle(delta)
		CROW_WANDER_STATE:
			do_wander()
#	velocity = move_and_slide(velocity)
	
	
func do_idle(delta: float) -> void:
	# velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# if velocity
	pass
	
	
func do_wander() -> void:
	pass


func check_for_player():
	if (state == CROW_IDLE_STATE && playerDetectionZone.can_see_player()):
		state = CROW_TAKEOFF_STATE
		animationPlayer.play(CROW_TAKEOFF_ANIMATION)
		


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == CROW_TAKEOFF_ANIMATION && state == CROW_TAKEOFF_STATE):
		state = CROW_WANDER_STATE
		animationPlayer.play(CROW_FLY_ANIMATION)
