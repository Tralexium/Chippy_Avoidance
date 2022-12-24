extends Sprite3D


func _ready() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, 0.05)
	tween.tween_callback(self, "queue_free").set_delay(0.05)
