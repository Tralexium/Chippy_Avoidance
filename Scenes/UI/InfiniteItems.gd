extends CheckBox



func _on_InfiniteItems_toggled(button_pressed: bool) -> void:
	Config.infinite_items = button_pressed
