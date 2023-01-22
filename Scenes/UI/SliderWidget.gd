extends VBoxContainer

signal value_changed(value)

export var delimiter := "%"

onready var h_slider: HSlider = $HBoxContainer/HSlider
onready var percent: Label = $HBoxContainer/Percent


func set_value(value: float) -> void:
	h_slider.value = value
	percent.text = str(floor(value)) + delimiter


func _on_HSlider_value_changed(value: float) -> void:
	emit_signal("value_changed", value)
	set_value(value)


func _on_HSlider_drag_ended(value_changed: bool) -> void:
	SoundManager.play_sound(Globals.UI_ON)
