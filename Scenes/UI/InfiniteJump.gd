extends CheckBox



func _on_InfiniteJump_toggled(button_pressed: bool) -> void:
	Config.infinite_jump = button_pressed
