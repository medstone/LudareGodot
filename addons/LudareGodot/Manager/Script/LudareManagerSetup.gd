extends Node

@export var GameId: String
@export var GameSecret: String
@export var Platform: LudareManager.Platforms
@export var NetPromoterScoreMenu: PackedScene
@export var LoadingMenu: PackedScene
@export var HeatMapActive: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	LudareManager.Single.GameId = GameId
	LudareManager.Single.GameSecret = GameSecret
	LudareManager.Single.Platform = Platform
	LudareManager.Single.NetPromoterMenu = NetPromoterScoreMenu
	LudareManager.Single.HeatMapActive = HeatMapActive
	LudareManager.Single.LoadingScene = LoadingMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
