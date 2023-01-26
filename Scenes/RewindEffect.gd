extends ColorRect

signal faded_in
signal finished

const REWIND_SFX := preload("res://Audio/SFX/tape_rewind.wav")


func _ready() -> void:
	SoundManager.play_sound(REWIND_SFX)


func _faded_in() -> void:
	emit_signal("faded_in")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("finished")
	queue_free()
