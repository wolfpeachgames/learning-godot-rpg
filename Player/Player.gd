extends KinematicBody2D


# Called when the node enters the scene tree for the first time.
#func _ready():
#	print("Hello world")

# Called every 'tick' that physics update. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		print("You pressed the right arrow key")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
