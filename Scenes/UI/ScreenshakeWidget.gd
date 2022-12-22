extends CheckBox


func _on_Screenshake_toggled(button_pressed: bool) -> void:
	Config.screen_shake = button_pressed
