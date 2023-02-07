extends CanvasLayer

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")

var paused := false
var previous_time_scale := 1.0
var in_transition := false
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var resume_ring: TextureProgress = $Control/CenterContainer/ResumeRing
onready var resume_button: Button = $Control/UISpace/UIBG/VBoxContainer/Margin/Buttons/Resume
onready var tutorial_button: Button = $Control/UISpace/UIBG/VBoxContainer/Margin/Buttons/Tutorial


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if Globals.can_pause and event.is_action_pressed("escape"):
		pause()


func pause() -> void:
	paused = !paused
	if paused:
		show()
		if Globals.in_tutorial:
			tutorial_button.text = "Skip Tutorial"
		else:
			tutorial_button.text = "Tutorial"
		previous_time_scale = Engine.time_scale
		Engine.time_scale = 1.0
		animation_player.play("enable")
		resume_button.grab_focus()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		SoundManager.pause_music()
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


func spawn_transition(scene: PackedScene) -> void:
	for player in get_tree().get_nodes_in_group("player"):
		player.iframe_immunity = true
	in_transition = true
	var transition_inst := CIRCLE_TRANSITION.instance()
	transition_inst.connect("finished", self, "_on_transition_finished", [scene])
	transition_inst.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(transition_inst)


func _on_transition_finished(scene: PackedScene) -> void:
	resume_instant()
	in_transition = false
	var mus_bus := SoundManager.get_default_music_bus()
	AudioServer.set_bus_effect_enabled(mus_bus, 0, false)
	Engine.time_scale = 1.0
	SoundManager.stop_music()
	SoundManager.stop_all_sounds()
	get_tree().change_scene_to(scene)


func _on_Resume_pressed() -> void:
	if paused:
		pause()


func _on_Retry_pressed() -> void:
	if !in_transition:
		spawn_transition(Globals.AVOIDANCE)


func _on_Exit_pressed() -> void:
	if !in_transition:
		spawn_transition(Globals.MAIN_MENU)


func _on_Tutorial_pressed() -> void:
	if Globals.in_tutorial:
		spawn_transition(Globals.AVOIDANCE)
		Config.infinite_items = false
		Config.save_data()
	else:
		spawn_transition(Globals.TUTORIAL)
