extends Label


var tween : SceneTreeTween


func change_text(string: String) -> void:
	text = string
	percent_visible = 0.0
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "percent_visible", 1.0, 0.2)
