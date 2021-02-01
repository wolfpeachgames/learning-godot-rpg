extends Node2D

const CROW_IDLE_ANIMATION = "CrowIdle"

onready var animationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()

func _ready():
	# add a small random delay to the beginning of the looping animation so that all crows aren't moving in syncrony
	rng.randomize()
	rng = rng.randf_range(0.0, 2.0)
	yield(get_tree().create_timer(rng), "timeout")
	animationPlayer.play(CROW_IDLE_ANIMATION)
