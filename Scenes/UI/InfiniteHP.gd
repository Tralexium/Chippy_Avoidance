extends CheckBox



func _on_InfiniteHP_toggled(button_pressed: bool) -> void:
	Config.infinite_hp = button_pressed
