extends CanvasLayer

var paused = false
var previous_time_scale := 1.0
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
		SoundManager.music.pause()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		animation_player.play("disable")


func _resume() -> void:
	get_tree().paused = false
	Engine.time_scale = previous_time_scale
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SoundManager.music.resume(.25)


func _hide() -> void:
	hide()


func _on_Resume_pressed() -> void:
	if paused:
		pause()
