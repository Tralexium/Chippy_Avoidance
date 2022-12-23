extends CheckBox


func _on_ShowBar_toggled(button_pressed: bool) -> void:
	Config.show_bar = button_pressed
