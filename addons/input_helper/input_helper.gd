extends Node

signal device_changed(device, device_index)
signal action_key_changed(action_name, key)
signal action_button_changed(action_name, button)

const DEVICE_KEYBOARD = "keyboard"
const DEVICE_XBOX_CONTROLLER = "xbox"
const DEVICE_SWITCH_CONTROLLER = "switch"
const DEVICE_PLAYSTATION_CONTROLLER = "playstation"
const DEVICE_GENERIC = "generic"

const SONY_GAMEPAD_TEXTURES = {
	JOY_SONY_X: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Cross.png"),
	JOY_SONY_SQUARE: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Square.png"),
	JOY_SONY_TRIANGLE: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Triangle.png"),
	JOY_SONY_CIRCLE: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Circle.png"),
	JOY_DPAD_DOWN: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Dpad_Down.png"),
	JOY_DPAD_LEFT: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Dpad_Left.png"),
	JOY_DPAD_RIGHT: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Dpad_Right.png"),
	JOY_DPAD_UP: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Dpad_Up.png"),
	JOY_L: preload("res://Assets/Controller & Key Prompts/PS4/PS4_L1.png"),
	JOY_L2: preload("res://Assets/Controller & Key Prompts/PS4/PS4_L2.png"),
	JOY_L3: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Left_Stick_Click.png"),
	JOY_R: preload("res://Assets/Controller & Key Prompts/PS4/PS4_R1.png"),
	JOY_R2: preload("res://Assets/Controller & Key Prompts/PS4/PS4_R2.png"),
	JOY_R3: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Right_Stick_Click.png"),
	JOY_START: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Options.png"),
	JOY_SELECT: preload("res://Assets/Controller & Key Prompts/PS4/PS4_Share.png"),
}

var deadzone: float = 0.2

var device: String = DEVICE_GENERIC
var device_index: int = -1
var device_last_changed_at: int = 0


func _input(event: InputEvent) -> void:
	identify_current_input_device(event)


func identify_current_input_device(event: InputEvent) -> void:
	var next_device: String = device
	var next_device_index: int = device_index
	
	# Did we just press a key on the keyboard?
	if event is InputEventKey and event.is_pressed():
		next_device = DEVICE_KEYBOARD
		next_device_index = -1
	
	# Did we just use a gamepad?
	elif (event is InputEventJoypadButton and event.is_pressed()) \
		or (event is InputEventJoypadMotion and event.axis_value > deadzone):
		next_device = get_simplified_device_name(Input.get_joy_name(event.device))
		next_device_index = event.device
	
	# Debounce changes because some gamepads register twice in Windows for some reason
	var not_changed_just_then = Engine.get_idle_frames() - device_last_changed_at > Engine.get_frames_per_second()
	if next_device != device or (next_device_index != device_index and not_changed_just_then):
		device_last_changed_at = Engine.get_idle_frames()
		
		device = next_device
		device_index = next_device_index
		emit_signal("device_changed", device, device_index)


func get_simplified_device_name(raw_name: String) -> String:
	match raw_name:
		"XInput Gamepad", "Xbox Series Controller":
			return DEVICE_XBOX_CONTROLLER
		
		"Sony DualSense", "PS5 Controller", "PS4 Controller":
			return DEVICE_PLAYSTATION_CONTROLLER
		
		"Switch":
			return DEVICE_SWITCH_CONTROLLER
		
		_:
			return DEVICE_GENERIC


func has_gamepad() -> bool:
	return Input.get_connected_joypads().size() > 0


func guess_device_name() -> String:
	var connected_joypads = Input.get_connected_joypads()
	if connected_joypads.size() == 0:
		return DEVICE_KEYBOARD
	else:
		return get_simplified_device_name(Input.get_joy_name(0))


### Mapping


func reset_all_actions() -> void:
	InputMap.load_from_globals()
	for action in InputMap.get_actions():
		if guess_device_name() == DEVICE_KEYBOARD:
			emit_signal("action_key_changed", action, get_action_key(action))
		else:
			emit_signal("action_button_changed", action, get_action_button(action))


func is_valid_key(key: String) -> bool:
	if key.length() == 1: return true
	if key in [
			"Up", "Down", "Left", "Right", 
			"Space", "Enter", 
			"Slash", "Minus",
			"Semicolon", "Shift", "Control",
			"Delete", "Insert", "Home", "End",
			"PageUp", "PageDown",
			"Alt", "Tab", "Escape"
		]: return true
	return false


func get_action_key(action: String) -> String:
	for event in InputMap.get_action_list(action):
		if event is InputEventKey:
			var scancode = OS.keyboard_get_scancode_from_physical(event.physical_scancode) if event.physical_scancode != 0 else event.scancode
			return OS.get_scancode_string(scancode)
	return ""


func set_action_key(target_action: String, key: String, swap_if_taken: bool = true) -> int:
	if not is_valid_key(key): return ERR_INVALID_DATA
	
	# Find any action that is already mapped to this key
	var clashing_action = ""
	var clashing_event
	if swap_if_taken:
		for action in Config.get_configurable_actions():
			for event in InputMap.get_action_list(action):
				if event is InputEventKey and event.as_text() == key:
					clashing_action = action
					clashing_event = event
	
	# Find the key based event for the target action
	for event in InputMap.get_action_list(target_action):
		if event is InputEventKey:
			# Add the current mapping to the clashing action
			if clashing_action:
				InputMap.action_erase_event(clashing_action, clashing_event)
				InputMap.action_add_event(clashing_action, event)
				emit_signal("action_key_changed", clashing_action, event.as_text())
			# Remove the current mapping
			InputMap.action_erase_event(target_action, event)
			
	# Add the new event to the target action
	var next_event = InputEventKey.new()
	next_event.scancode = OS.find_scancode_from_string(key)
	InputMap.action_add_event(target_action, next_event)
	emit_signal("action_key_changed", target_action, next_event.as_text())
	return OK


func get_action_button(action: String) -> int:
	# Get the first button input
	for event in InputMap.get_action_list(action):
		if event is InputEventJoypadButton:
			return event.button_index
	return -1


func set_action_button(target_action: String, button: int, swap_if_taken: bool = true) -> int:
	# Find any action that is already mapped to this key
	var clashing_action = ""
	var clashing_event
	if swap_if_taken:
		for action in Config.get_configurable_actions():
			for event in InputMap.get_action_list(action):
				if event is InputEventJoypadButton and event.button_index == button:
					clashing_action = action
					clashing_event = event
	
	# Find the key based event for the target action
	for event in InputMap.get_action_list(target_action):
		if event is InputEventJoypadButton:
			# Add the current mapping to the clashing action
			if clashing_action:
				InputMap.action_erase_event(clashing_action, clashing_event)
				InputMap.action_add_event(clashing_action, event)
				emit_signal("action_button_changed", clashing_action, event.button_index)
			# Remove the current mapping
			InputMap.action_erase_event(target_action, event)
			
	# Add the new event to the target action
	var next_event = InputEventJoypadButton.new()
	next_event.button_index = button
	InputMap.action_add_event(target_action, next_event)
	emit_signal("action_button_changed", target_action, next_event.button_index)
	return OK



### Rumbling


func rumble_small(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0.5, 0.0, 0.2)


func rumble_medium(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0, 0.7, 0.25)


func rumble_large(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0.5, 1, 0.5)


func start_rumble_small(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0.4, 0, 0)


func start_rumble_medium(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0, 0.7, 0)


func start_rumble_large(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.start_joy_vibration(target_device, 0.5, 1, 0)


func stop_rumble(target_device: int = 0) -> void:
	if Config.gamepad_rumble:
		Input.stop_joy_vibration(target_device)
