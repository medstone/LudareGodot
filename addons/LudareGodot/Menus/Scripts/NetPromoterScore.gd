extends Control

var RadioButtons
var SubmitButton
var ExitButton
var NPSHttp: HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	NPSHttp = HTTPRequest.new()
	add_child(NPSHttp)
	
	SubmitButton = get_node("Panel/SubmitButton")
	SubmitButton.pressed.connect(self._onSubmit)
	
	ExitButton = get_node("Panel/ExitButton")
	ExitButton.pressed.connect(self._onClose)
	
	RadioButtons = get_node("Panel/Panel/Value0").get_button_group()
	
	_getNetPromoter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _onClose():
	get_tree().quit()
	pass
	
func _npsLoad():
	LudareManager.Single._startLoading()
	SubmitButton.disabled = true
	ExitButton.disabled = true
	for choice in RadioButtons.get_buttons():
		choice.disabled = true
	
func _npsEndLoad():
	SubmitButton.disabled = false
	ExitButton.disabled = false
	for choice in RadioButtons.get_buttons():
		choice.disabled = false
	LudareManager.Single._endLoading()

func _onSubmit():
	var score = RadioButtons.get_pressed_button().name.substr(5)
	_submitNetPromoter(score)
	pass

func _submitNetPromoter(score: String):
	_npsLoad()
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/RegisterNetPromoter"
	NPSHttp.request_completed.connect(self._setNetPromoterResponse)
	var playerId = LudareManager.Single.PlayerId
	var gameId = LudareManager.Single.GameId
	var gameSession = LudareManager.Single.GameSession
	
	NPSHttp.request(url, headers, HTTPClient.METHOD_POST, "{ \"userid\": \"" + playerId + "\", \"netPromoterScore\": \"" + score + "\", \"gameId\": \"" + gameId + "\", \"sessionId\": \"" + gameSession + "\" }")
	pass

func _setNetPromoterResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["success"] == true:
		get_tree().quit()
	else:
		_npsEndLoad()
	pass

func _getNetPromoter():
	_npsLoad()
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/GetNetPromoter"
	NPSHttp.request_completed.connect(self._getNetPromoterResponse)
	var playerId = LudareManager.Single.PlayerId
	var gameId = LudareManager.Single.GameId
	
	NPSHttp.request(url, headers, HTTPClient.METHOD_POST, "{ \"userid\": \"" + playerId + "\", \"gameId\": \"" + gameId + "\" }")
	pass

func _getNetPromoterResponse(result, response_code, headers, body):
	_npsEndLoad()
	NPSHttp.request_completed.disconnect(self._getNetPromoterResponse)
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["success"] == true:
		var score = json["message"]
		for button in RadioButtons.get_buttons():
			if button.name == "Value" + str(score):
				button.button_pressed = true
	pass
