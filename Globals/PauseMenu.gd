extends CanvasLayer

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")

var paused := false
var previous_time_scale := 1.0
var in_transition := false
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var resume_ring: TextureProgress = $Control/CenterContainer/ResumeRing
onready var resume_button: Button = $Control/UISpace/UIBG/VBoxContainer/Margin/Buttons/Resume


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if Globals.can_pause and event.is_action_pressed("escape"):
		pause()


func pause() -> void:
	paused = !paused
	if paused:
		show()
		previous_time_scale = Engine.time_scale
		Engine.time_scale = 1.0
		animation_player.play("enable")
		resume_button.grab_focus()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		animation_player.play("disable")


func _resume() -> void:
	get_tree().paused = false
	Engine.time_scale = previous_time_scale
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SoundManager.resume_music(.25)


func resume_instant() -> void:
	paused = false
	get_tree().paused = false
	Engine.time_scale = previous_time_scale
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	animation_player.play("RESET")
	hide()


func _hide() -> void:
	hide()


func spawn_transition(back_to_menu: bool) -> void:
	in_transition = true
	var transition_inst := CIRCLE_TRANSITION.instance()
	transition_inst.connect("finished", self, "_on_transition_finished", [back_to_menu])
	transition_inst.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(transition_inst)


func _on_transition_finished(back_to_menu: bool) -> void:
	resume_instant()
	in_transition = false
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, false)
	Engine.time_scale = 1.0
	SoundManager.stop_music()
	SoundManager.stop_all_sounds()
	if back_to_menu:
		get_tree().change_scene_to(Globals.MAIN_MENU)
	else:
		get_tree().reload_current_scene()


func _on_Resume_pressed() -> void:
	if paused:
		pause()


func _on_Retry_pressed() -> void:
	if !in_transition:
		spawn_transition(false)


func _on_Exit_pressed() -> void:
	if !in_transition:
		spawn_transition(true)
