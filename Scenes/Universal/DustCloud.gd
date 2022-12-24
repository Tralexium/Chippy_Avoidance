extends MeshInstance


func _ready() -> void:
	rotation = Vector3(randf()*180.0, randf()*180.0, randf()*180.0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).parallel()
	tween.tween_property(self, "translation:y", 1.0, 0.5)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
