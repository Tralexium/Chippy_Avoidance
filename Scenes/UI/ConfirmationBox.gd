extends ColorRect

signal answered(answer)

export var text := ""
onready var yes_button: Button = $CenterContainer/Panel/MarginContainer/Contents/Buttons/Yes
onready var label: Label = $CenterContainer/Panel/MarginContainer/Contents/Label


func _ready() -> void:
	label.text = text
	hide()


func show_box() -> void:
	yes_button.grab_focus()
	show()


func _answer(answer: bool) -> void:
	if visible:
		hide()
		emit_signal("answered", answer)
		SoundManager.play_ui_sound(Globals.UI_OFF)


func _on_Yes_pressed() -> void:
	_answer(true)


func _on_No_pressed() -> void:
	_answer(false)
