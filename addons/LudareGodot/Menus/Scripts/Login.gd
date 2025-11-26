extends Node
class_name LoginScreen

var UsernameField
var PasswordField
var SubmitButton
var ExitButton
var Callbacks: Dictionary
var closeAfter = 1.0
var close = false
var LoginMessage
var RememberField

# Called when the node enters the scene tree for the first time.
func _ready():
	UsernameField = get_node("Panel/Label/LineEdit")
	PasswordField = get_node("Panel/Label2/LineEdit")
	SubmitButton = get_node("Panel/Button")
	LoginMessage = get_node("Panel/Result")
	RememberField = get_node("Panel/Label3/CheckBox")
	SubmitButton.pressed.connect(self._submitPressed)
	ExitButton = get_node("Panel/Exit")
	ExitButton.pressed.connect(self._onClose)
	if(LudareManager.Single.StoredUsername != null):
		UsernameField.text = LudareManager.Single.StoredUsername
	if(LudareManager.Single.StoredHash != null):
		PasswordField.placeholder_text = "****************************"
	
func _registerClose():
	var exitButton = get_node("Panel/Exit")
	exitButton.pressed.connect(self._onClose)

func _submitPressed():
	LudareManager.Single._addOnResponse(self, Callable(self, "_onResponse"))
	UsernameField.editable = false
	PasswordField.editable = false
	RememberField.disabled = true
	SubmitButton.disabled = true
	ExitButton.disabled = true
	if(PasswordField.text == "" ):
		LudareManager.Single._tryLoginLudare(UsernameField.text, LudareManager.Single.StoredHash, true, RememberField.button_pressed)
	else:
		LudareManager.Single._tryLoginLudare(UsernameField.text, PasswordField.text, false, RememberField.button_pressed)

func _onResponse(success: bool):
	UsernameField.editable = true
	PasswordField.editable = true
	RememberField.disabled = false
	SubmitButton.disabled = false
	ExitButton.disabled = false
	if success == true:
		close = true
		LoginMessage.text = "Login Sucessful"
	else:
		LoginMessage.text = "Login Failed"
	
func _addOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == false):
		Callbacks[parent] = callback
		
func _removeOnClose(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == true && Callbacks[parent] == callback):
		Callbacks[parent] = null
		
func _callOnClose():
	for callback in Callbacks.values():
		if callback != null:
			callback.call()
			
func _onClose():
	print("Base Login Close")
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
