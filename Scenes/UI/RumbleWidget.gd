extends CheckBox


func _on_Rumble_toggled(button_pressed: bool) -> void:
	Config.gamepad_rumble = button_pressed
