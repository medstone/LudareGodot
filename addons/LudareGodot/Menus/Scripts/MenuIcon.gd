extends Node

@export var PlatformSelect: PackedScene
@export var LoginScreen: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._buttonPressed)

func _buttonPressed():
	var inst
	if LudareManager.Single.Platform != 0:
		inst = PlatformSelect.instantiate()
	else:
		inst = LoginScreen.instantiate()
	get_tree().root.add_child(inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
