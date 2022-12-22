extends CheckBox


func _on_VSync_toggled(button_pressed: bool) -> void:
	Config.vsync = button_pressed
