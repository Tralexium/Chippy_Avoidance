extends Area

export var phase := -1


func _on_TutorialPhaseClearArea_body_entered(body: Node) -> void:
	EventBus.emit_signal("tutorial_phase_finished", phase)
	queue_free()
