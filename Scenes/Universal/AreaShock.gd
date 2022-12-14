extends Area


func _ready() -> void:
	var _delay := 0.5
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	tween.tween_property(self, "scale", Vector3.ZERO, _delay)
	tween.tween_callback(self, "queue_free").set_delay(_delay)
