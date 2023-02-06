extends CanvasLayer

signal faded_out
signal faded_in

export var fade_dur := 0.35
export var delete_on_fade := false
onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	fade()


func fade() -> void:
	var tween := create_tween()
	if color_rect.color.a == 0.0:
		tween.tween_property(color_rect, "color:a", 1.0, fade_dur)
		tween.tween_callback(self, "emit_signal", ["faded_in"])
	else:
		tween.tween_property(color_rect, "color:a", 0.0, fade_dur)
		tween.tween_callback(self, "emit_signal", ["faded_out"])
	if delete_on_fade:
		tween.tween_callback(self, "queue_free")
