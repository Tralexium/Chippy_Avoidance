extends CheckBox



func _on_PlayerRing_toggled(button_pressed: bool) -> void:
	Config.player_ring = button_pressed
