extends Sprite


const CONTROL_ATTACK = "attack"


func _process(delta):
	if (Input.is_action_just_pressed(CONTROL_ATTACK)):
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance()
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		grassEffect.global_position = global_position
		queue_free()
