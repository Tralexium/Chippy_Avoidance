extends Node

const SAVE_PATH := "user://data_config.save"
const GAME_VERSION := "1.0.0"

enum SCREEN_MODES {
	FULLSCREEN, BORDERLESS, WINDOWED
}

enum AA_MODES {
	DISABLED, FXAA, MSAA2X, MSAA4X,
	MSAA8X, MSAA16X
}

var music_volume := 70.0 setget set_music_volume
var sound_volume := 100.0 setget set_sound_volume
var resolution := Vector2(1920, 1080) setget set_resolution
var screen_mode : int = SCREEN_MODES.FULLSCREEN setget set_screen_mode
var aa_mode : int = AA_MODES.MSAA4X setget set_aa_mode
var vsync := true setget set_vsync
var bloom := true setget set_bloom
var screen_shake := true setget set_screen_shake

signal bloom_changed(is_active)


func save_data() -> void:
	var save_dict := {}
	save_dict["music_volume"] = music_volume
	save_dict["sound_volume"] = sound_volume
	save_dict["resolution"] = resolution
	save_dict["screen_mode"] = screen_mode
	save_dict["aa_mode"] = aa_mode
	save_dict["vsync"] = vsync
	save_dict["bloom"] = bloom
	save_dict["screen_shake"] = screen_shake
	save_dict["keyboard_controls"] = get_keyboard_dict()
	save_dict["gamepad_controls"] = get_gamepad_dict()
	var file := File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_var(save_dict)
	file.close()


func load_data() -> void:
	var file := File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var values : Dictionary = file.get_var()
		
		self.music_volume = values.get("music_volume", 70.0)
		self.sound_volume = values.get("sound_volume", 100.0)
		self.resolution = values.get("resolution", Vector2(1920, 1080))
		self.screen_mode = values.get("screen_mode", SCREEN_MODES.FULLSCREEN)
		self.aa_mode = values.get("screen_mode", AA_MODES.MSAA4X)
		self.vsync = values.get("vsync", true)
		self.bloom = values.get("bloom", true)
		self.screen_shake = values.get("screen_shake", true)
		
		var keyboard_controls : Dictionary = values.get("keyboard_controls", {})
		for action in keyboard_controls:
			InputHelper.set_action_key(action, keyboard_controls[action])
		
		var gamepad_controls : Dictionary = values.get("gamepad_controls", {})
		for action in gamepad_controls:
			InputHelper.set_action_button(action, gamepad_controls[action])
		
		file.close()
	else:
		save_data()


func set_music_volume(value: float) -> void:
	music_volume = value
	SoundManager.set_music_volume(value / 100.0)


func set_sound_volume(value: float) -> void:
	sound_volume = value
	SoundManager.set_sound_volume(value / 100.0)


func set_bloom(value: bool) -> void:
	bloom = value
	emit_signal("bloom_changed", value)


func set_screen_shake(value: bool) -> void:
	screen_shake = value


func set_resolution(value: Vector2) -> void:
	resolution = value
	OS.window_size = value



func set_aa_mode(mode: int) -> void:
	aa_mode = mode
	var viewport := get_tree().get_root()
	viewport.fxaa = false
	viewport.msaa = Viewport.MSAA_DISABLED
	match mode:
		AA_MODES.FXAA:
			viewport.fxaa = true
		AA_MODES.MSAA2X:
			viewport.msaa = Viewport.MSAA_2X
		AA_MODES.MSAA4X:
			viewport.msaa = Viewport.MSAA_4X
		AA_MODES.MSAA8X:
			viewport.msaa = Viewport.MSAA_8X
		AA_MODES.MSAA16X:
			viewport.msaa = Viewport.MSAA_16X
	


func set_screen_mode(mode: int) -> void:
	screen_mode = mode
	match mode:
		SCREEN_MODES.FULLSCREEN:
			OS.window_fullscreen = true
			OS.window_borderless = false
		SCREEN_MODES.BORDERLESS:
			OS.window_fullscreen = false
			OS.window_borderless = true
			OS.window_maximized = true
		SCREEN_MODES.WINDOWED:
			OS.window_fullscreen = false
			OS.window_borderless = false
			OS.window_maximized = false
			OS.window_size = resolution
			# Center window
			var screen_size = OS.get_screen_size()
			var window_size = OS.get_window_size()
			OS.set_window_position(screen_size*0.5 - window_size*0.5)


func set_vsync(value: bool) -> void:
	vsync = value
	OS.vsync_enabled = value


func get_configurable_actions() -> Array:
	return [
		"jump", "left", "right", "forward", "backward", "quick restart",
		"escape", "item 1", "item 2", "item 3", "item 4",
	]


func get_keyboard_dict() -> Dictionary:
	var dict := {}
	for action in get_configurable_actions():
		dict[action] = InputHelper.get_action_key(action)
	return dict


func get_gamepad_dict() -> Dictionary:
	var dict := {}
	for action in get_configurable_actions():
		dict[action] = InputHelper.get_action_button(action)
	return dict
