extends Node

enum Platforms {Ludare, Steam, Epic}
const PlatformStrings = {Platforms.Ludare: "Ludare", Platforms.Steam: "Steam", Platforms.Epic: "Epic"}

var LoginHttp: HTTPRequest
var EventHttp: HTTPRequest
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
var StoredUsername
var StoredHash
var CredentialsFile = "user://../Ludare/Credentials.txt"
var EventsFile = "user://../Ludare/LocalEvents.txt"
var EventRequests: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Single = self
	LoginHttp = HTTPRequest.new()
	add_child(LoginHttp)
	EventHttp = HTTPRequest.new()
	add_child(EventHttp)
	Callbacks = {}
	if(FileAccess.file_exists(CredentialsFile) == true):
		var credFile = FileAccess.open(CredentialsFile, FileAccess.READ)
		StoredUsername = credFile.get_line()
		StoredHash = credFile.get_line()
		credFile.close()
	_tryUploadData()

func _tryLoginLudare(username, password, hashed, remember):
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/GameLogin"
	LoginHttp.request_completed.connect(self._tryLoginResponse)
	StoredUsername = username
	
	print(str(remember))
	LoginHttp.request(url, headers, HTTPClient.METHOD_POST, "{ \"password\": \"" + password + "\", \"hashed\": \"" + str(hashed) + "\", \"secret\": \"" + GameSecret + "\", \"returnHash\": \"" + str(remember) + "\", \"username\": \"" + username + "\" }")
	
func _tryGetID(platform, id):
	var headers = ["Content-Type: application/json"]
	var url = "https://www.devpowered.com:8000/GetUserID?platform=" + platform + "&userid=" + str(id) +"&secret=" + GameSecret
	LoginHttp.request_completed.connect(self._tryPlatformResponse)
	
	LoginHttp.request(url, headers, HTTPClient.METHOD_GET)
	
func _ludarePostUpdate(eventType):
	var headers = ["Content-Type: application/json"]
	var requestEntry = {}
	requestEntry["url"] = "https://www.devpowered.com:8000" + eventType
	EventHttp.request_completed.connect(self._eventResponse)
	requestEntry["message"] = "{ \"userid\": \"" + PlayerId + "\", \"gameid\": \"" + GameId + "\", \"timestamp\": \"" + str(Time.get_unix_time_from_system()) + "\", \"secret\": \"" + GameSecret + "\" }"
	EventHttp.request(requestEntry["url"], headers, HTTPClient.METHOD_POST, requestEntry["message"])
	EventRequests.push_back(requestEntry)

func _tryLoginResponse(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	var json = JSON.parse_string(body.get_string_from_utf8())
	LoggedIn = json["success"]
	if LoggedIn == true:
		PlayerId = str(json["message"])
		_ludarePostUpdate("/RegisterGameStart")
		if(json.has("hash") == true):
			var credFile = FileAccess.open(CredentialsFile, FileAccess.WRITE)
			credFile.store_line(StoredUsername)
			credFile.store_line(json["hash"])
			credFile.close()
		else:
			if(FileAccess.file_exists(CredentialsFile) == true):
				DirAccess.remove_absolute(CredentialsFile)
	_callOnResponse()

func _eventResponse(result, response_code, headers, body):
	var event = EventRequests.pop_front()
	if(result != HTTPRequest.RESULT_SUCCESS):
		var eventString = JSON.stringify(event)
		eventString.replace("\n" , "")
		eventString.replace("\r" , "")
		var eventsFile = FileAccess.open(EventsFile, FileAccess.WRITE)
		eventsFile.store_line(JSON.stringify(event))
		eventsFile.close()
		
	
func _tryPlatformResponse(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	LoggedIn = json["success"]
	if LoggedIn == true:
		PlayerId = str(json["LudareID"])
		_ludarePostUpdate("/RegisterGameStart")
	_callOnResponse()

func _tryLoginPlatform():
	if Platform == LudareManager.Platforms.Steam:
		#var steamId = Steam.getSteamID()
		#_tryGetID("Steam", steamId)
		return
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
		return
	
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

func _tryUploadData():
	var headers = ["Content-Type: application/json"]
	if(FileAccess.file_exists(EventsFile) == false):
		return
	var eventsFile = FileAccess.open(EventsFile, FileAccess.READ)
	var readLine = eventsFile.get_line()
	var eventTable = JSON.parse_string(readLine)
	while (readLine != null && eventTable != null):
		EventHttp.request_completed.connect(self._eventResponse)
		EventHttp.request(eventTable["url"], headers, HTTPClient.METHOD_POST, eventTable["message"])
		EventRequests.push_back(eventTable)
		readLine = eventsFile.get_line()
		eventTable = JSON.parse_string(readLine)
	eventsFile.close()
	DirAccess.remove_absolute(EventsFile)
