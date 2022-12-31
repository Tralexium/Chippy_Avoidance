extends Control

export var fade_dur := 0.1

signal go_back

var is_showing := false
var is_present := false
onready var contents: Control = $AspectRatioContainer/MarginContainer/Contents
onready var current_node := contents.get_child_count() - 1
onready var fade_in_timer: Timer = $FadeIn
onready var fade_out_timer: Timer = $FadeOut


func _ready() -> void:
	hide_credits()


func _unhandled_input(event: InputEvent) -> void:
	if is_present and event.is_action_pressed("ui_cancel"):
		_go_back()


func hide_credits() -> void:
	if is_showing:
		return
	if current_node > 0:
		var node := contents.get_child(current_node-1)
		var tween := create_tween()
		tween.tween_property(node, "modulate:a", 0.0, fade_dur)
		current_node -= 1
		fade_out_timer.start(fade_dur)


func fade_in_credits() -> void:
	is_showing = true
	is_present = true
	if current_node < contents.get_child_count():
		var node := contents.get_child(current_node)
		var tween := create_tween()
		tween.tween_property(node, "modulate:a", 1.0, fade_dur)
		current_node += 1
		fade_in_timer.start(fade_dur)
	else:
		is_showing = false


func _go_back() -> void:
	is_present = false
	hide_credits()
	emit_signal("go_back")


func _on_BackToMenu_pressed() -> void:
	_go_back()


func _on_FadeIn_timeout() -> void:
	fade_in_credits()


func _on_FadeOut_timeout() -> void:
	hide_credits()
