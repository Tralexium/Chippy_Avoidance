extends MeshInstance

const SFX_SPAWN := preload("res://Audio/SFX/ability_shield.wav")
const SFX_EXPIRE := preload("res://Audio/SFX/ability_shield_expired.wav")
const SFX_FRACTURE := preload("res://Audio/SFX/ability_shield_break.wav")

signal hidden

func _ready() -> void:
	hide()
	scale = Vector3.ZERO


func _hide() -> void:
	hide()
	emit_signal("hidden")


func fracture() -> void:
	hide()
	scale = Vector3.ZERO
	SoundManager.play_sound(SFX_FRACTURE)


func scale_to(new_scale: float) -> void:
	show()
	var tween := create_tween().set_trans(Tween.TRANS_BACK)
	if new_scale <= 0.0:
		tween.set_ease(Tween.EASE_IN).tween_property(self, "scale", Vector3.ONE * new_scale, 0.4)
		tween.tween_callback(self, "_hide").set_delay(0.4)
		SoundManager.play_sound(SFX_EXPIRE)
	else:
		tween.set_ease(Tween.EASE_OUT).tween_property(self, "scale", Vector3.ONE * new_scale, 0.4)
		SoundManager.play_sound(SFX_SPAWN)
