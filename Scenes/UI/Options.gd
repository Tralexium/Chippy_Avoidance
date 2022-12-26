extends Control

signal go_back

var is_present := false

onready var music: VBoxContainer = $BG/Margin/Contents/General/Audio/Music
onready var sounds: VBoxContainer = $BG/Margin/Contents/General/Audio/Sounds
onready var resolution: VBoxContainer = $BG/Margin/Contents/General/Resolution
onready var screen_mode: VBoxContainer = $BG/Margin/Contents/General/ScreenMode
onready var anti_aliasing: VBoxContainer = $BG/Margin/Contents/General/AntiAliasing
onready var v_sync: CheckBox = $BG/Margin/Contents/General/Toggles/VSync
onready var bloom: CheckBox = $BG/Margin/Contents/General/Toggles/Bloom
onready var game_version: Label = $BG/Footer/GameVersion
onready var show_bar: CheckBox = $BG/Margin/Contents/General/Toggles/ShowBar
onready var percentage: CheckBox = $BG/Margin/Contents/General/Toggles/Percentage
onready var player_hud: CheckBox = $BG/Margin/Contents/General/Toggles/PlayerHUD
onready var show_fps: CheckBox = $BG/Margin/Contents/General/Toggles/ShowFPS
onready var screenshake: VBoxContainer = $BG/Margin/Contents/Accessibility/Slidables/Screenshake
onready var point_multiplier: VBoxContainer = $BG/Margin/Contents/Accessibility/Slidables/PointMultiplier
onready var player_ring: CheckBox = $BG/Margin/Contents/Accessibility/Toggles/PlayerRing
onready var infinite_hp: CheckBox = $BG/Margin/Contents/Accessibility/Toggles/InfiniteHP
onready var infinite_jump: CheckBox = $BG/Margin/Contents/Accessibility/Toggles/InfiniteJump
onready var infinite_items: CheckBox = $BG/Margin/Contents/Accessibility/Toggles/InfiniteItems


func fetch_and_set_general_setting() -> void:
	music.set_value(Config.music_volume * 100.0)
	sounds.set_value(Config.sound_volume * 100.0)
	screenshake.set_value(Config.screen_shake * 100.0)
	point_multiplier.set_value(Config.point_multiplier * 100.0)
	resolution.find_and_select(Config.resolution)
	screen_mode.find_and_select(Config.screen_mode)
	anti_aliasing.find_and_select(Config.aa_mode)
	v_sync.pressed = Config.vsync
	bloom.pressed = Config.bloom
	show_bar.pressed = Config.show_bar
	percentage.pressed = Config.show_percentage
	player_hud.pressed = Config.always_show_hud
	show_fps.pressed = Config.show_fps
	player_ring.pressed = Config.player_ring
	infinite_hp.pressed = Config.infinite_hp
	infinite_jump.pressed = Config.infinite_jump
	infinite_items.pressed = Config.infinite_items
	game_version.text = "game version: " + Config.GAME_VERSION


func _unhandled_input(event: InputEvent) -> void:
	if is_present and event.is_action_pressed("ui_cancel"):
		is_present = false
		save_and_go_back()


func focus() -> void:
	is_present = true
	$BG/Margin/Contents/Tabs/GeneralTab.grab_focus()
	$BG/Margin/Contents._on_GeneralTab_pressed()


func lose_focus() -> void:
	get_focus_owner().release_focus()


func save_and_go_back() -> void:
	Config.save_data()
	lose_focus()
	emit_signal("go_back")


func _on_Music_value_changed(value) -> void:
	Config.music_volume = value / 100.0


func _on_Sounds_value_changed(value) -> void:
	Config.sound_volume = value / 100.0


func _on_Screenshake_value_changed(value) -> void:
	Config.screen_shake = value / 100.0


func _on_PointMultiplier_value_changed(value) -> void:
	Config.point_multiplier = value / 100.0


func _on_BackToMenu_pressed() -> void:
	save_and_go_back()
