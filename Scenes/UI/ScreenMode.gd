extends VBoxContainer

onready var option_button := $OptionButton


func find_and_select(mode: int) -> void:
	var mode_str : String = option_button.get_item_text(mode)
	for i in option_button.get_item_count():
		if mode_str == option_button.get_item_text(i):
			option_button.select(i)


func _on_OptionButton_item_selected(index: int) -> void:
	SoundManager.play_ui_sound(Globals.UI_OFF)
	match option_button.get_item_text(index):
		"fullscreen":
			Config.screen_mode = Config.SCREEN_MODES.FULLSCREEN
		"borderless":
			Config.screen_mode = Config.SCREEN_MODES.BORDERLESS
		"windowed":
			Config.screen_mode = Config.SCREEN_MODES.WINDOWED


func _on_OptionButton_pressed() -> void:
	SoundManager.play_ui_sound(Globals.UI_BUTTON)
