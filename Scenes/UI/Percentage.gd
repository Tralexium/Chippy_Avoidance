extends CheckBox


func _on_Percentage_toggled(button_pressed: bool) -> void:
	Config.show_percentage = button_pressed
