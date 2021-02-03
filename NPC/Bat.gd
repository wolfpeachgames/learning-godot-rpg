extends KinematicBody2D

export var ACCELERATION = 250
export var FRICTION = 100
export var MAX_MOVEMENT_SPEED = 45
export var WANDER_BUFFER = 3
export var INVINCIBLE_DURATION = 0.4

enum { IDLE_STATE, WANDER_STATE, CHASE_STATE }

const START_BLINK_ANIMATION = "StartBlink"
const STOP_BLINK_ANIMATION = "StopBlink"

const NPCDeathEffect = preload("res://Effects/NPCDeathEffect.tscn")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = WANDER_STATE
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollisionComponent
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer


func _ready():
	sprite.play()


# every physics tick
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE_STATE:
			do_idle(delta)
		WANDER_STATE:
			do_wander(delta)
		CHASE_STATE:
			do_chase(delta)
	
	if (softCollision.is_colliding()):
		velocity += softCollision.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)


func seek_player():
	if (playerDetectionZone.can_see_player()):
		state = CHASE_STATE


# on hurtbox collision detection
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(INVINCIBLE_DURATION)


# on no health signal from stats
func _on_Stats_no_health():
	var npcDeathEffect = NPCDeathEffect.instance()
	self.get_parent().add_child(npcDeathEffect)
	npcDeathEffect.global_position = self.global_position
	self.queue_free()


func do_idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seek_player()
	should_change_state()


func do_wander(delta):
	seek_player()
	should_change_state()
	accelerate_towards_point(wanderController.target_position, delta)
	if (global_position.distance_to(wanderController.target_position) <= WANDER_BUFFER):
		change_state()


func do_chase(delta):
	var player  = playerDetectionZone.player
	if (player != null):
		accelerate_towards_point(player.global_position, delta)
	else:
		state = IDLE_STATE


func accelerate_towards_point(point, delta):
	var direction_vector = global_position.direction_to(point)
	velocity = velocity.move_toward(direction_vector * MAX_MOVEMENT_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0


func should_change_state():
	if (wanderController.get_time_left() <= 0):
		change_state()


func change_state():
	state = pick_random_state([IDLE_STATE, WANDER_STATE])
	wanderController.start_wander_timer(rand_range(0.2, 1.0))


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_Hurtbox_invincibility_started():
	animationPlayer.play(START_BLINK_ANIMATION)


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play(STOP_BLINK_ANIMATION)
