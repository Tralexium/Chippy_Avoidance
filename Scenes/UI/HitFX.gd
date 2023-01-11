extends Control


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
