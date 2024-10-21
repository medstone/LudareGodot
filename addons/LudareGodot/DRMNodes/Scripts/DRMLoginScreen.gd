extends LoginScreen

@export var ExitMenu: PackedScene

func _onClose():
	if(LudareManager.Single.LoggedIn == true):
		return
	var exitInst = ExitMenu.instantiate()
	get_tree().root.add_child(exitInst)
	
func _closeOnSuccess():
	self.queue_free()
	pass
