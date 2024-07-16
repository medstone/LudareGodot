extends Node

@export var LoginScreen: PackedScene
@export var PlatformIconMap: Dictionary
var PlatformIcon
var PlatformName
var LoginMessage
var closeAfter = 1.0
var close = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var PlatformButton = get_node("Panel/PlatformPanel")
	PlatformButton.pressed.connect(self._platformSelected)
	
	var LudareButton = get_node("Panel/LudarePanel")
	LudareButton.pressed.connect(self._ludareSelected)
	
	var ExitButton = get_node("Panel/Exit")
	ExitButton.pressed.connect(self._onClose)
	
	LoginMessage = get_node("Panel/Message")
	
	PlatformIcon = get_node("Panel/PlatformPanel/PlatformIcon")
	PlatformName = get_node(("Panel/PlatformPanel/PlatformLabel"))
	
	PlatformName.text = LudareManager.PlatformStrings[LudareManager.Single.Platform]
	if PlatformIconMap.has(LudareManager.Single.Platform):
		PlatformIcon.texture = PlatformIconMap[LudareManager.Single.Platform]

func _platformSelected():
	LudareManager.Single._addOnResponse(self, Callable(self, "_onLoginResponse"))
	LudareManager.Single._tryLoginPlatform()
	
func _ludareSelected():
	var inst = LoginScreen.instantiate()
	get_tree().root.add_child(inst)
	inst._addOnClose(self, Callable(self, "_onClose"))

func _onClose():
	self.queue_free()
	
func _onLoginResponse(success):
	print(success)
	LudareManager.Single._removeOnResponse(self, Callable(self, "_onLoginResponse"))
	if success == true:
		close = true
		LoginMessage.text = "Login Sucessful"
	else:
		LoginMessage.text = "Login Failed"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if close == true:
		closeAfter -= delta
		if closeAfter <= 0:
			_onClose()
