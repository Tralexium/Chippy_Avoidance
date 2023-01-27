extends Spatial

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")
const REWIND_FX := preload("res://Scenes/RewindEffect.tscn")
const SLOMO_FX := preload("res://Scenes/UI/SlomoEffect.tscn")
const HIT_FX := preload("res://Scenes/UI/HitFX.tscn")

export var starting_hp := 2

onready var using_gamepad := InputHelper.has_gamepad()
onready var tutorial_texts := [
	"Welcome, feel free to move around with the {0}!".format(["joystick" if using_gamepad else "arrow keys"]),
	"Believe it or not, you can jump up to 2 times. Try it out!",
]

var tutorial_phase := -1
var currently_restarting := false
var audio_stream_player: AudioStreamPlayer
onready var ability_border_fx: Control = $FX/AbilityBorderFX
onready var respawn_timer: Timer = $RespawnTimer
onready var next_phase_timer: Timer = $NextPhase
onready var player: KinematicBody = $Player
onready var hp_hud: Control = $UI/PlayerHUD/HPHUD
onready var player_hud: Control = $UI/PlayerHUD
onready var info_box: Panel = $UI/InfoBox
onready var camera_pos: Position3D = $Player/CameraPos


func _ready() -> void:
	EventBus.connect("hp_changed", self, "_on_damage_taken")
	EventBus.connect("ability_used", self, "_on_ability_used")
	EventBus.connect("avoidance_ended", self, "_on_avoidance_ended")
	EventBus.connect("tutorial_phase_finished", self, "_on_tutorial_phase_finished")
	audio_stream_player = SoundManager.play_music(Globals.TUTORIAL_MUSIC, 0.0, "Music")
	hp_hud.set_bars(starting_hp)
	player.set_only_hp(starting_hp)
	camera_pos.shift_cam(Vector3(0, 0, 6), Vector3(-30, 0, 0), 2.0, Tween.EASE_OUT, Tween.TRANS_CUBIC, 50)


func _process(delta: float) -> void:
	if !currently_restarting:
		audio_stream_player.pitch_scale = Engine.time_scale
	# local condition checking
	match tutorial_phase:
		0:
			var xy_input := Input.get_vector("left", "right", "forward", "backward", 0.2)
			if xy_input.length() > 0.0:
				info_box_complete()


func spawn_info_box() -> void:
	var text : String = tutorial_texts[tutorial_phase]
	info_box.slide_in(text)


func info_box_complete() -> void:
	if info_box.is_visible:
		info_box.complete()
		next_phase_timer.start()


# SIGNALS:

func _on_tutorial_phase_finished(phase: int) -> void:
	if phase == -1 or phase == tutorial_phase:
		info_box_complete()


func _on_ability_used(ability_num: int) -> void:
	if ability_num == Globals.ABILITIES.SLO_MO:
		$FX.add_child(SLOMO_FX.instance())
	else:
		ability_border_fx.enable_effect(ability_num)


func _on_damage_taken(new_hp: int) -> void:
	$FX.add_child(HIT_FX.instance())


func _on_avoidance_ended() -> void:
	respawn_timer.start()
	info_box.slide_out()


func _on_RespawnTimer_timeout() -> void:
	SoundManager.pause_music(0.3)
	var yaaah_its_rewind_time := REWIND_FX.instance()
	yaaah_its_rewind_time.connect("faded_in", self, "_on_rewind_faded_in")
	yaaah_its_rewind_time.connect("finished", self, "_on_rewind_finished")
	$FX.add_child(yaaah_its_rewind_time)


func _on_rewind_faded_in() -> void:
	player.revive(Vector3(0.0, 2.0, 0.0), starting_hp)
	hp_hud.set_bars(starting_hp)


func _on_rewind_finished() -> void:
	SoundManager.resume_music(0.3)
	player_hud.slide_in()
	spawn_info_box()


func _on_NextPhase_timeout() -> void:
	tutorial_phase += 1
	if tutorial_phase < tutorial_texts.size():
		spawn_info_box()
	else:
		# FINISH
		return
