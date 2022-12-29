extends MeshInstance


func _ready() -> void:
	hide()
	scale = Vector3.ZERO


func scale_to(new_scale: float) -> void:
	show()
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector3.ONE * new_scale, 0.3)
	if new_scale <= 0.0:
		tween.tween_callback(self, "hide").set_delay(0.3)
