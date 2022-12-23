extends CheckBox



func _on_PlayerHUD_toggled(button_pressed: bool) -> void:
	Config.always_show_hud = button_pressed
