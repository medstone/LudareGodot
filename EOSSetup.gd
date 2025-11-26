extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the SDK
	#var init_opts = EOS.Platform.InitializeOptions.new()
	#init_opts.product_name = "Ludare"
	#init_opts.product_version = "1.0"

	#var init_res := EOS.Platform.PlatformInterface.initialize(init_opts)
	#if not EOS.is_success(init_res):
	#	print("Failed to initialize EOS SDK: ", EOS.result_str(init_res))
	#	return

	# Create platform
	#var create_opts = EOS.Platform.CreateOptions.new()
	#create_opts.product_id = "b135527c07ec4abdb67bf865fd19701f"
	#create_opts.sandbox_id = "2995d448ee9a46a6b72317f67dbd7002"
	#create_opts.deployment_id = "372b020cde35446db52125a8dfa2a57e"
	#create_opts.client_id = "xyza7891yUZ9T5c0Ei459DIUyKn7vglR"
	#create_opts.client_secret = "xDU6x1qr/RSCEZLiOmohAli62Fxr2+cR788qOda9hLw"

	# Enable Social Overlay on Windows
	#if OS.get_name() == "Windows":
	#	create_opts.flags = EOS.Platform.PlatformFlags.WindowsEnableOverlayOpengl

	#var create_success := EOS.Platform.PlatformInterface.create(create_opts)
	#if not create_success:
		print("Failed to create EOS Platform")
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
