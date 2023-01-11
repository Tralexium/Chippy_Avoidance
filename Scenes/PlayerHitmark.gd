extends Sprite3D

var shrink_dur := 0.5

func _ready() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ZERO, shrink_dur)
	tween.tween_callback(self, "queue_free").set_delay(shrink_dur)
