extends Node

var UsernameField
var PasswordField
var Callbacks: Dictionary
var closeAfter = 1.0
var close = false
var LoginMessage

# Called when the node enters the scene tree for the first time.
func _ready():
	UsernameField = get_node("Panel/Panel/Label/LineEdit")
	PasswordField = get_node("Panel/Panel/Label2/LineEdit")
	var submitButton = get_node("Panel/Panel/Button")
	var exitButton = get_node("Panel/Exit")
	LoginMessage = get_node("Panel/Panel/Result")
	submitButton.pressed.connect(self._submitPressed)
	exitButton.pressed.connect((self._onClose))

func _submitPressed():
	LudareManager.Single._addOnResponse(self, Callable(self, "_onResponse"))
	LudareManager.Single._tryLoginLudare(UsernameField.text, PasswordField.text)

func _onResponse(success: bool):
	LudareManager.Single._removeOnResponse(self, Callable(self, "_onResponse"))
	if success == true:
		close = true
		LoginMessage.text = "Login Sucessful"
	else:
		LoginMessage.text = "Login Failed"
	
func _addOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == false):
		Callbacks[parent] = callback
		
func _removeOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == false):
		Callbacks[parent] = callback
		
func _callOnClose():
	for callback in Callbacks.values():
		if callback != null:
			callback.call()
			
func _onClose():
	self.queue_free()

func _closeOnSuccess():
	_callOnClose()
	_onClose()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if close == true:
		closeAfter -= delta
		if closeAfter <= 0:
			_closeOnSuccess()
