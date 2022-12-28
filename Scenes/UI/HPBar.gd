extends Panel


func shrink() -> void:
	$AnimationPlayer.play("shrink")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
