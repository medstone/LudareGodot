extends Node

static var TrackedItems = []

# Called when the node enters the scene tree for the first time.
func _ready():
	TrackedItems.push_back(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _exit_tree():
	TrackedItems.erase(self)
