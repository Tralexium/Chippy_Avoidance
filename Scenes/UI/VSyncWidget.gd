extends CheckBox

var audible := false


func _on_VSync_toggled(button_pressed: bool) -> void:
	Config.vsync = button_pressed
	if !audible:
		return
	if button_pressed:
		SoundManager.play_ui_sound(Globals.UI_ON)
	else:
		SoundManager.play_ui_sound(Globals.UI_OFF)
