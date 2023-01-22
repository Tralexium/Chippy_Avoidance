extends CheckBox

var audible := false


func _on_Rumble_toggled(button_pressed: bool) -> void:
	Config.gamepad_rumble = button_pressed
	if !audible:
		return
	if button_pressed:
		SoundManager.play_ui_sound(Globals.UI_ON)
		InputHelper.rumble_medium()
	else:
		SoundManager.play_ui_sound(Globals.UI_OFF)
