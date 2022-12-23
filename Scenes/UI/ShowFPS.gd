extends CheckBox


func _on_ShowFPS_toggled(button_pressed: bool) -> void:
	Config.show_fps = button_pressed
