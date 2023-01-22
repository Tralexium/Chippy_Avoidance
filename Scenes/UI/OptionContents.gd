extends VBoxContainer


func change_tabs() -> void:
	SoundManager.play_ui_sound(Globals.UI_BUTTON)
	for tab in get_children():
		if tab.name != "Tabs" and tab.name != "Header":
			tab.hide()
	for button in $Tabs.get_children():
		button.disabled = false
		button.pressed = false


func _on_GeneralTab_pressed() -> void:
	change_tabs()
	$Tabs/GeneralTab.disabled = true
	$Tabs/GeneralTab.pressed = true
	$General.show()


func _on_ControlsTab_pressed() -> void:
	change_tabs()
	$Tabs/ControlsTab.disabled = true
	$Tabs/ControlsTab.pressed = true
	$Controls.show()


func _on_AccessibilityTab_pressed() -> void:
	change_tabs()
	$Tabs/AccessibilityTab.disabled = true
	$Tabs/AccessibilityTab.pressed = true
	$Accessibility.show()
