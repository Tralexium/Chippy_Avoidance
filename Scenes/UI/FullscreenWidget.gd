extends CheckBox


func _on_Fullscreen_toggled(button_pressed: bool) -> void:
	Config.fullscreen = button_pressed
