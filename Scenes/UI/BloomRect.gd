extends ColorRect

func _process(delta: float) -> void:
	if Config.bloom:
		visible = true
	else:
		visible = false
