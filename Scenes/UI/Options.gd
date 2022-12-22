extends Control

onready var music: VBoxContainer = $BG/Margin/Contents/General/Audio/Music
onready var sounds: VBoxContainer = $BG/Margin/Contents/General/Audio/Sounds
onready var resolution: VBoxContainer = $BG/Margin/Contents/General/Resolution
onready var fullscreen: CheckBox = $BG/Margin/Contents/General/Toggles/Fullscreen
onready var v_sync: CheckBox = $BG/Margin/Contents/General/Toggles/VSync
onready var bloom: CheckBox = $BG/Margin/Contents/General/Toggles/Bloom
onready var screenshake: CheckBox = $BG/Margin/Contents/General/Toggles/Screenshake
onready var game_version: Label = $BG/Footer/GameVersion


func _ready() -> void:
	fetch_and_set_general_setting()


func fetch_and_set_general_setting() -> void:
	music.set_value(Config.music_volume)
	sounds.set_value(Config.sound_volume)
	resolution.find_and_select(Config.resolution)
	fullscreen.pressed = Config.fullscreen
	v_sync.pressed = Config.fullscreen
	bloom.pressed = Config.bloom
	screenshake.pressed = Config.screen_shake
	game_version.text = "game version: " + Config.GAME_VERSION
