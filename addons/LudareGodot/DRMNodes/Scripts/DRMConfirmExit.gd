extends Node

var Callbacks: Dictionary
var ConfirmButton
var DenyButton

# Called when the node enters the scene tree for the first time.
func _ready():
	ConfirmButton = get_node("Panel/ConfirmButton")
	DenyButton = get_node("Panel/DenyButton")
	ConfirmButton.pressed.connect(self._onConfirm)
	DenyButton.pressed.connect(self._onDeny)
	pass # Replace with function body.


func _onConfirm():
	get_tree().quit()

func _onDeny():
	for callback in Callbacks.values():
		if callback != null:
			callback.call()
	self.queue_free()

func _addOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == false):
		Callbacks[parent] = callback

func _removeOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == true && Callbacks[parent] == callback):
		Callbacks[parent] = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
