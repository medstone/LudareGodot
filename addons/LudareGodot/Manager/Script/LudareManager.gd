extends Node

enum Platforms {Ludare, Steam, Epic}
const PlatformStrings = {Platforms.Ludare: "Ludare", Platforms.Steam: "Steam", Platforms.Epic: "Epic"}

var Http: HTTPRequest
var Single
var GameId: String
var GameSecret: String
var Platform: Platforms
var OnClose: Callable
var Callbacks: Dictionary
var LoggedIn: bool
var PlayerId: String
var MaxUpdateTimer = 300
var UpdateTimer = MaxUpdateTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	Single = self
	Http = HTTPRequest.new()
	add_child(Http)
	Callbacks = {}

func _tryLoginLudare(username, password):
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/GameLogin"
	Http.request_completed.connect(self._tryLoginResponse)
	
	Http.request(url, headers, HTTPClient.METHOD_POST, "{ \"password\": \"" + password + "\", \"username\": \"" + username + "\" }")
	
func _tryGetID(platform, id):
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/GetUserID?platform=" + platform + "&userid=" + str(id)
	Http.request_completed.connect(self._tryPlatformResponse)
	
	Http.request(url, headers, HTTPClient.METHOD_GET)
	
func _ludarePostUpdate(eventType):
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000" + eventType
	Http.request_completed.connect(self._eventResponse)
	
	Http.request(url, headers, HTTPClient.METHOD_POST, "{ \"userid\": \"" + PlayerId + "\", \"gameid\": \"" + GameId + "\", \"secret\": \"" + GameSecret + "\" }")

func _tryLoginResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	LoggedIn = json["success"]
	print("Log Result")
	print(LoggedIn)
	if LoggedIn == true:
		PlayerId = str(json["message"])
		_ludarePostUpdate("/RegisterGameStart")
	_callOnResponse()

func _eventResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	LoggedIn = json["success"]
	print(LoggedIn)
	print(result)
	
func _tryPlatformResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	LoggedIn = json["success"]
	print("Log Result")
	print(LoggedIn)
	if LoggedIn == true:
		PlayerId = str(json["LudareID"])
		_ludarePostUpdate("/RegisterGameStart")
	_callOnResponse()

func _tryLoginPlatform():
	if Platform == LudareManager.Platforms.Steam:
		#var steamId = Steam.getSteamID()
		#_tryGetID("Steam", steamId)
		pass
	if Platform == LudareManager.Platforms.Epic:
		#var creds = EOS.Auth.Credentials.new()
		#creds.type = EOS.Auth.LoginCredentialType.AccountPortal
		#creds.id = ""
		#creds.token = ""
		
		#var loginOpts = EOS.Auth.LoginOptions.new()
		#loginOpts.credentials = creds
		#loginOpts.scope_flags = EOS.Auth.ScopeFlags.BasicProfile
		#EOS.Auth.AuthInterface.login(loginOpts)
		#IEOS.auth_interface_login_callback.connect(_eosLoginCallback)
		pass
	
func _eosLoginCallback(data: Dictionary):
	if data.success == true:
		_tryGetID("Epic", str(data.selected_account_id))
	
func _addOnResponse(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == false):
		Callbacks[parent] = callback
		
func _removeOnResponse(parent: Node, callback: Callable):
	if(Callbacks.has(parent) == true):
		Callbacks[parent] = null
		
func _callOnResponse():
	for callback in Callbacks.values():
		if callback != null:
			callback.call(LoggedIn)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if LoggedIn == true:
		UpdateTimer -= delta
		if UpdateTimer <= 0:
			_ludarePostUpdate("/RegisterGameContinue")
			UpdateTimer = MaxUpdateTimer
	pass
