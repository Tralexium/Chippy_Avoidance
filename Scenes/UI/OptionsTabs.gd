extends HBoxContainer


func unlock_tabs() -> void:
	for button in get_children():
		button.disabled = false
		button.toggled = false


func _on_GeneralTab_pressed() -> void:
	unlock_tabs()
	$GeneralTab.disabled = true


func _on_ControlsTab_pressed() -> void:
	unlock_tabs()
	$ControlsTab.disabled = true


func _on_AccessibilityTab_pressed() -> void:
	unlock_tabs()
	$AccessibilityTab.disabled = true
