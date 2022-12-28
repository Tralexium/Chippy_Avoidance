extends CheckBox



func _on_PlayerHUD_toggled(button_pressed: bool) -> void:
	Config.transparent_hud = button_pressed
