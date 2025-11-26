extends Node

@export var DRMLoginScreen: PackedScene
@export var SceneToLoad: PackedScene
@export var DontLoadScene: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var loginInst = DRMLoginScreen.instantiate()
	get_tree().root.add_child.call_deferred(loginInst)
	LudareManager.Single._addOnResponse(self, Callable(self, "_onResponse"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onResponse(success: bool):
	if(success == true):
		LudareManager.Single._removeOnResponse(self, Callable(self, "_onResponse"))
		if(DontLoadScene != true):
			get_tree().change_scene_to_packed(SceneToLoad)
		self.queue_free()
