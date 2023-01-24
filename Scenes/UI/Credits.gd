extends Control

export var fade_dur := 0.1

signal go_back

var is_showing := false
var is_present := false
onready var contents: Control = $AspectRatioContainer/MarginContainer/Contents
onready var current_node := contents.get_child_count()
onready var fade_in_timer: Timer = $FadeIn
onready var fade_out_timer: Timer = $FadeOut


func _ready() -> void:
	hide_credits()


func _unhandled_input(event: InputEvent) -> void:
	if is_present and event.is_action_pressed("ui_cancel"):
		_go_back()


func hide_credits() -> void:
	fade_in_timer.stop()
	if is_showing:
		return
	current_node = 0
	for node in contents.get_children():
		node.modulate.a = 0.0


func fade_in_credits() -> void:
	fade_out_timer.stop()
	is_showing = true
	is_present = true
	_show_next_line()


func _show_next_line() -> void:
	if current_node < contents.get_child_count():
		var node := contents.get_child(current_node)
		var tween := create_tween()
		tween.tween_property(node, "modulate:a", 1.0, fade_dur)
		fade_in_timer.start(fade_dur)
		current_node += 1
	else:
		is_showing = false


func _go_back() -> void:
	is_present = false
	fade_out_timer.start(0.5)
	SoundManager.play_ui_sound(Globals.UI_BACK)
	emit_signal("go_back")


func _on_BackToMenu_pressed() -> void:
	_go_back()


func _on_FadeIn_timeout() -> void:
	_show_next_line()


func _on_FadeOut_timeout() -> void:
	hide_credits()
