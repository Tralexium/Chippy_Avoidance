extends CanvasLayer

export var reverse := false
onready var color_rect: ColorRect = $ColorRect
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	color_rect.material.set_shader_param("screen_width", Config.resolution.x)
	color_rect.material.set_shader_param("screen_height", Config.resolution.y)
	if reverse:
		animation_player.play("reverse_start")
	else:
		animation_player.play("start")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
