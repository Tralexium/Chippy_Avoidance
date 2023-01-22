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
		"Disabled":
			Config.aa_mode = Config.AA_MODES.DISABLED
		"FXAA":
			Config.aa_mode = Config.AA_MODES.FXAA
		"MSAA 2x":
			Config.aa_mode = Config.AA_MODES.MSAA2X
		"MSAA 4x":
			Config.aa_mode = Config.AA_MODES.MSAA4X
		"MSAA 8x":
			Config.aa_mode = Config.AA_MODES.MSAA8X
		"MSAA 16x":
			Config.aa_mode = Config.AA_MODES.MSAA16X


func _on_OptionButton_pressed() -> void:
	SoundManager.play_ui_sound(Globals.UI_BUTTON)
