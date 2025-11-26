extends Node3D

var cube

# Called when the node enters the scene tree for the first time.
func _ready():
	cube = get_node("CSGBox3D")
	LudareManager.Single._ludareQuit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("UpdateScene"):
		cube.queue_free()
	pass
