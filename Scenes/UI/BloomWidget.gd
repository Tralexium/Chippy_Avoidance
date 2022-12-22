extends CheckBox


func _on_Bloom_toggled(button_pressed: bool) -> void:
	Config.bloom = button_pressed
