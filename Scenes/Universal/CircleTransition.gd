extends CanvasLayer

onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.material.set_shader_param("screen_width", Config.resolution.x)
	color_rect.material.set_shader_param("screen_height", Config.resolution.y)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
