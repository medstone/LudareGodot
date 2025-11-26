extends Node

var Spinner
var SpinRate = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Spinner = get_node("Panel/Spinner-of-dots")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Spinner.rotation = Spinner.rotation + (SpinRate * delta)
	pass
