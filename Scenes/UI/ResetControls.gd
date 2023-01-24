extends Button


func _on_ResetControls_pressed() -> void:
	SoundManager.play_ui_sound(Globals.UI_OFF)
	InputHelper.reset_all_actions()
