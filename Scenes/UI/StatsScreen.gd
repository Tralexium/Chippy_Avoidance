extends Control

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var stats_header: ColorRect = $UISpace/UIBG/VBoxContainer/StatsHeader


func _input(event: InputEvent) -> void:
	return
	if animation_player.is_playing() and (event.is_action_pressed("jump") or event.is_action_pressed("escape")):
		var anim_length := animation_player.get_animation("fade_in").length
		animation_player.advance(anim_length)
		yield(get_tree(), "idle_frame")
		stats_header.rect_size.x = Config.resolution.x


func expand_header() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(stats_header, "rect_size:x", Config.resolution.x, 0.3)


func _on_Retry_pressed() -> void:
	EventBus.emit_signal("avoidance_restart")
