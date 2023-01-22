extends CheckBox

var audible := false


func _on_PlayerHUD_toggled(button_pressed: bool) -> void:
	Config.transparent_hud = button_pressed
	if !audible:
		return
	if button_pressed:
		SoundManager.play_ui_sound(Globals.UI_ON)
	else:
		SoundManager.play_ui_sound(Globals.UI_OFF)
