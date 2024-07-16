extends Node

@export var GameId: String
@export var GameSecret: String
@export var Platform: LudareManager.Platforms

# Called when the node enters the scene tree for the first time.
func _ready():
	LudareManager.Single.GameId = GameId
	LudareManager.Single.GameSecret = GameSecret
	LudareManager.Single.Platform = Platform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
