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

func _ready():
	sprite.play()

# every physics tick
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE_STATE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER_STATE:
			pass
		CHASE_STATE:
			var player  = playerDetectionZone.player
			if (player != null):
				var direction_vector = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction_vector * MAX_MOVEMENT_SPEED, ACCELERATION * delta)
			else:
				state = IDLE_STATE
			sprite.flip_h = velocity.x < 0
	
	
	velocity = move_and_slide(velocity)


func seek_player():
	if (playerDetectionZone.can_see_player()):
		state = CHASE_STATE

# on hurtbox collision detection
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100

# on no health signal from stats
func _on_Stats_no_health():
	var npcDeathEffect = NPCDeathEffect.instance()
	self.get_parent().add_child(npcDeathEffect)
	npcDeathEffect.global_position = self.global_position
	self.queue_free()
