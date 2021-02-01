extends AnimatedSprite

const EFFECT_ANIMATION = "EffectAnimation"

func _ready():
	# connect the "animation_finished" signal to the "_on_animation_finished" function
	self.connect("animation_finished", self, "_on_animation_finished")
	# set start frame of animation
	self.frame = 0
	self.play(EFFECT_ANIMATION)


func _on_animation_finished():
	# destroy self
	self.queue_free()
