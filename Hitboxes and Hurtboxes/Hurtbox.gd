extends Area2D

# export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D


func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = self.global_position


func start_invincibility(duration: float):
	self.invincible = true
	timer.start(duration)


func set_invincible(value):
	invincible = value
	if (invincible):
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_ended():
	collisionShape.set_deferred("disabled", false)


func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)
