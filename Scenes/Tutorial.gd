extends Spatial

const CIRCLE_TRANSITION := preload("res://Scenes/Universal/CircleTransition.tscn")
const REWIND_FX := preload("res://Scenes/RewindEffect.tscn")
const SLOMO_FX := preload("res://Scenes/UI/SlomoEffect.tscn")
const HIT_FX := preload("res://Scenes/UI/HitFX.tscn")

export var starting_hp := 1

onready var using_gamepad := InputHelper.has_gamepad()
onready var tutorial_texts := [
	"Welcome, feel free to move around using the {0}.".format(["joystick" if using_gamepad else "arrow keys"]),
	"Believe it or not, you can jump up to 2 times. Try jumping again mid-air!",
	"Try to avoid red obstacles. Let's put your movement skills into use.",
	"When in 2D, only horizontal movement is allowed. Keep an eye on the top left corner when unsure.",
	"Grayed out projectiles are harmless and tend to be smaller.",
	"Coins are only for score, only go for them if wanna be a big shot!",
	"Time for some powerups! Super Speed is handy when it comes jumping over long gaps.",
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
onready var tutorial_phase_3: Spatial = $ObstacleSpawners/Tutorial_Phase3
onready var tutorial_phase_4: Spatial = $ObstacleSpawners/Tutorial_Phase4
onready var tutorial_phase_5: Spatial = $ObstacleSpawners/Tutorial_Phase5
onready var tutorial_phase_6: Spatial = $ObstacleSpawners/Tutorial_Phase6


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
			var xy_input := Input.get_vector("left", "right", "forward", "backward", 0.0)
			var joystick_input := Input.get_vector("left_stick", "right_stick", "forward_stick", "backward_stick", 0.2)
			if xy_input.length() + joystick_input.length() > 0.0:
				info_box_complete()


func spawn_info_box() -> void:
	var text : String = tutorial_texts[tutorial_phase]
	info_box.slide_in(text)
	match tutorial_phase:
		2:
			tutorial_phase_3.start()
		3:
			tutorial_phase_4.start()
		4:
			tutorial_phase_5.start()
		5:
			tutorial_phase_6.start()


func info_box_complete() -> void:
	if info_box.is_visible:
		info_box.complete()
		next_phase_timer.start()


# SIGNALS:

func _on_tutorial_phase_finished(phase: int) -> void:
	if !info_box.is_visible:
		return
	if phase == -1 or phase == tutorial_phase:
		info_box_complete()
		match phase:
			1:
				camera_pos.shift_cam(Vector3(0, 0, 6), Vector3(-40, 0, 0), 2.0, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC, 45)
			2:
				camera_pos.switch_projection(true)
				camera_pos.shift_cam(Vector3(0, 3, 0), Vector3(0, 0, 0), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC, 45)
				camera_pos.set_position_y_angle(180, 0.5)
				player.lock_2d = true
			4:
				camera_pos.switch_projection(false)
				camera_pos.shift_cam(Vector3(0, 0, 3), Vector3(-50, 0, 0), 0.5, Tween.EASE_OUT, Tween.TRANS_CUBIC, 50)
				player.lock_2d = false
			5:
				camera_pos.shift_cam(Vector3(0, 0, 6), Vector3(-40, 0, 0), 2.0, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC, 45)


func _on_ability_used(ability_num: int) -> void:
	if ability_num == Globals.ABILITIES.SLO_MO:
		$FX.add_child(SLOMO_FX.instance())
	else:
		ability_border_fx.enable_effect(ability_num)


func _on_damage_taken(new_hp: int) -> void:
	$FX.add_child(HIT_FX.instance())


func _on_avoidance_ended() -> void:
	respawn_timer.start()
	if info_box.is_visible:
		info_box.slide_out()
	for obstacle in get_tree().get_nodes_in_group("hazard"):
		obstacle.shrink()
	for obstacle in get_tree().get_nodes_in_group("collectable"):
		obstacle.shrink()


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
	if info_box.is_visible:
		spawn_info_box()


func _on_NextPhase_timeout() -> void:
	tutorial_phase += 1
	if tutorial_phase < tutorial_texts.size():
		spawn_info_box()
	else:
		# FINISH
		return
