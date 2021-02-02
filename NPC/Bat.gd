extends KinematicBody2D

export var ACCELERATION = 250
export var FRICTION = 100
export var MAX_MOVEMENT_SPEED = 45

enum { IDLE_STATE, WANDER_STATE, CHASE_STATE }

const NPCDeathEffect = preload("res://Effects/NPCDeathEffect.tscn")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE_STATE
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollisionComponent


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


# on no health signal from stats
func _on_Stats_no_health():
	var npcDeathEffect = NPCDeathEffect.instance()
	self.get_parent().add_child(npcDeathEffect)
	npcDeathEffect.global_position = self.global_position
	self.queue_free()


func do_idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seek_player()


func do_wander(delta):
	pass


func do_chase(delta):
	var player  = playerDetectionZone.player
	if (player != null):
		var direction_vector = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_vector * MAX_MOVEMENT_SPEED, ACCELERATION * delta)
	else:
		state = IDLE_STATE
	sprite.flip_h = velocity.x < 0