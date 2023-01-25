extends Node

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var starting_menu: Control = $UI/StartingMenu
onready var options: Control = $UI/Options
onready var credits: Control = $UI/Credits


func _ready() -> void:
	options.fetch_and_set_general_setting()
	Globals.can_pause = false
	SoundManager.play_music(Globals.MAIN_MENU_MUSIC)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventBus.emit_signal("main_menu_started")


func _on_StartingMenu_options_pressed() -> void:
	animation_player.play("move_to_options")
	options.focus()


func _on_StartingMenu_credits_pressed() -> void:
	animation_player.play("move_to_credits")
	credits.fade_in_credits()


func _on_Options_go_back() -> void:
	animation_player.play("move_to_main_from_options")


func _on_Credits_go_back() -> void:
	animation_player.play("move_to_main_from_credits")


func _on_StartingMenu_exit_pressed() -> void:
	SoundManager.pause_music(1.5)
	var transition_inst := CIRCLE_TRANSITION.instance()
	add_child(transition_inst)
	yield(transition_inst, "finished")
	get_tree().quit()


func _on_StartingMenu_begin_pressed() -> void:
	SoundManager.pause_music(1.5)
	var transition_inst := CIRCLE_TRANSITION.instance()
	add_child(transition_inst)
	yield(transition_inst, "finished")
	get_tree().change_scene_to(Globals.AVOIDANCE)


