extends VBoxContainer

signal value_changed(value)

onready var h_slider: HSlider = $HBoxContainer/HSlider
onready var percent: Label = $HBoxContainer/Percent


func set_value(value: float) -> void:
	h_slider.value = value
	percent.text = str(floor(value)) + "%"


func _on_HSlider_value_changed(value: float) -> void:
	emit_signal("value_changed", value)
	set_value(value)
