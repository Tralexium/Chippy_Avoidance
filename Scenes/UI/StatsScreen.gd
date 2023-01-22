extends Control

var in_upgrades := false
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var stats_header: ColorRect = $"%StatsHeader"
onready var buttons: HBoxContainer = $"%Buttons"



func _input(event: InputEvent) -> void:
	# NOT IN USE: skips the animations when pressing some keys
	if false and animation_player.is_playing() and (event.is_action_pressed("jump") or event.is_action_pressed("escape")):
		var anim_length := animation_player.get_animation("fade_in").length
		animation_player.advance(anim_length)
		yield(get_tree(), "idle_frame")
		stats_header.rect_size.x = Config.resolution.x
	var is_focused := false
	for button in buttons.get_children():
		is_focused = button.has_focus()
		if is_focused:
			break
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length() > 0.0 and !is_focused:
		buttons.get_node("Retry").grab_focus()
		accept_event()


func expand_header() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(stats_header, "rect_min_size:x", Config.resolution.x, 0.3)


func _on_Retry_pressed() -> void:
	EventBus.emit_signal("avoidance_restart")


func _on_Upgrades_pressed() -> void:
	in_upgrades = !in_upgrades
	if in_upgrades:
		animation_player.play("goto_upgrades")
	else:
		animation_player.play_backwards("goto_upgrades")
