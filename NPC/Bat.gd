extends KinematicBody2D

const FRICTION = 200

var knockback = Vector2.ZERO

const NPCDeathEffect = preload("res://Effects/NPCDeathEffect.tscn")

onready var stats = $Stats

# every physics tick
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

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
